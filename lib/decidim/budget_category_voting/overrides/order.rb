# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    module Overrides
      module Order
        module InstanceMethods
          def category_class_for(rule)
            if projects_rule? && rule.fetch("vote_selected_projects_maximum", 0).to_i.zero?
              rule.merge!(vote_minimum_budget_projects_number: rule.fetch("vote_selected_projects_minimum", 0).to_i)
              Decidim::BudgetCategoryVoting::CategoryOrder::MinimumProject.new(self, rule)
            elsif projects_rule?
              Decidim::BudgetCategoryVoting::CategoryOrder::Project.new(self, rule)
            elsif minimum_projects_rule?
              Decidim::BudgetCategoryVoting::CategoryOrder::MinimumProject.new(self, rule)
            else
              Decidim::BudgetCategoryVoting::CategoryOrder::Percentage.new(self, rule)
            end
          end
        end

        def self.prepended(base)
          base.include InstanceMethods

          base.class_eval do
            def categories
              @categories ||= budget.category_budget_rules.collect { |rule| category_class_for(rule) }
            end

            def categories_can_checkout
              errors.add(:categories) unless categories.collect(&:valid?).all?
            end

            alias_method :legacy_can_checkout?, :can_checkout?
            private :legacy_can_checkout?

            validate :categories_can_checkout, if: :checked_out?

            def can_checkout?
              categories.all?(&:can_checkout?) && legacy_can_checkout?
            end
          end
        end
      end
    end
  end
end
