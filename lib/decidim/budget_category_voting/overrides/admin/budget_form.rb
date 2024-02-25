# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    module Overrides
      module Admin
        module BudgetForm
          def self.prepended(base)
            base.class_eval do
              attribute :category_budget_rules, Array[Decidim::BudgetCategoryVoting::Admin::CategoryBudgetRuleForm]

              validate :category_budget_rules_validator

              def map_model(model)
                self.category_budget_rules = available_categories(model).each do |category|
                  Decidim::BudgetCategoryVoting::Admin::CategoryBudgetRuleForm.new(category)
                end
              end

              protected
              delegate :settings, to: :current_component
              def available_categories(model)
                return @available_categories if @available_categories

                @available_categories = {}

                model.category_budget_rules.each do |category|
                  @available_categories[category["decidim_category_id"]] = category
                end

                @available_categories = @available_categories.values
                @available_categories.each { |c| c.transform_keys!(&:to_sym) }
              end

              def active_rule
                return "projects_value"  if settings.vote_rule_minimum_budget_projects_enabled
                return "minimum_value"   if settings.vote_rule_selected_projects_enabled
                return "threshold_value" if settings.vote_rule_threshold_percent_enabled
              end

              def category_budget_rules_validator
                @category_budget_rules_validator ||= begin
                                                       @validated_value = 0

                                                       category_budget_rules.reject(&:deleted).each do |category_rule|
                                                         case active_rule
                                                         when "threshold_value"
                                                           @validated_value += category_rule.vote_threshold_percent.to_i
                                                           category_rule.errors.add(:vote_threshold_percent) if @validated_value.to_i > settings.vote_threshold_percent.to_i
                                                         else
                                                           errors.add(:category_budget_rules) if category_rule.invalid?
                                                         end
                                                       end
                end
              end
            end
          end
        end
      end
    end
  end
end
