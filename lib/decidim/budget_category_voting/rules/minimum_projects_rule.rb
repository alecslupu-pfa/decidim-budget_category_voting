# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    module Rules
      class MinimumProjectsRule < GenericRule
        def current_rule_explanation
          t(".minimum_projects_rule.instruction_html", minimum_number: minimum_projects)
        end

        def caption
          t("rule.remaining_votes")
        end

        def remaining_votes
          count = minimum_projects - current_allocation
          count >= 0 ? count : 0
        end

        def current_allocation
          @current_allocation ||= current_order.projects_count_for_rule(model)
        end

        private

        def minimum_projects
          model.fetch("vote_minimum_budget_projects_number", 0).to_i
        end
      end
    end
  end
end
