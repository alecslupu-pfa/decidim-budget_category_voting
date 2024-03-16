# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    module Overrides
      module Order
        def self.prepended(base)
          base.class_eval do

            validate :budget_category_validation

            def budget_category_validation
              if projects_rule?
                errors.add(:base, :total_budget) unless projects_rules_condition_valid?
              elsif minimum_projects_rule?
                errors.add(:base, :total_budget) unless minimum_projects_condition_valid?
              else
                errors.add(:base, :total_budget) unless minimum_budget_condition_valid?
              end
            end

            def can_checkout?
              if projects_rule?
                projects_rules_condition_valid?
              elsif minimum_projects_rule?
                minimum_projects_condition_valid?
              else
                minimum_budget_condition_valid?
              end
            end

            def projects_in_category_satisfied?(type, comparator)
              return false unless budget

              budget.category_budget_rules.all? do |category_budget_rule|
                projects_count_for_rule(category_budget_rule).send(comparator, category_budget_rule.fetch(type, 0).to_i)
              end
            end

            def projects_sum_for_rule(category_budget_rule)
              projects.with_category(category_for(category_budget_rule)).sum(:budget_amount)
            end

            def projects_count_for_rule(category_budget_rule)
              projects.with_category(category_for(category_budget_rule)).count
            end

            def category_for(category_budget_rule)
              budget.participatory_space.categories.find(category_budget_rule.fetch("decidim_category_id", 0))
            end

            def minimum_budget_condition_valid?
              total_budget.to_f >= minimum_budget
            end

            def minimum_projects_condition_valid?
              [
                projects_in_category_satisfied?("vote_minimum_budget_projects_number", :>=),
                total_projects >= minimum_projects
              ].all?
            end

            def projects_rules_condition_valid?
              [
                projects_in_category_satisfied?("vote_selected_projects_minimum", :>=),
                projects_in_category_satisfied?("vote_selected_projects_maximum", :<=),
                total_projects >= minimum_projects,
                total_projects <= maximum_projects
              ].all?
            end

            def allocation_for(project)
              return 1 if projects_rule? || minimum_projects_rule?

              project.budget_amount
            end
          end
        end
      end
    end
  end
end
