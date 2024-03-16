# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    module Rules
      class PercentageRule < GenericRule
        include ActionView::Helpers::NumberHelper

        def caption = t("rule.remaining_votes")

        def current_rule_explanation
          t("vote_threshold_percent_rule.instruction_html", minimum_budget: budget_to_currency(minimum_allocation))
        end

        def remaining_votes
          count = computed_percentage - current_allocation
          count >= 0 ? number_to_percentage(count) : 0
        end

        def current_allocation
          @current_allocation ||= begin
            currently_selected = current_order.projects_sum_for_rule(model)
            (currently_selected.to_f / current_order.budget.total_budget) * 100
          end
        end

        def total_allocation
          current_order.budget.total_budget
        end

        private
        def minimum_allocation
          model.fetch("vote_threshold_percent", 0).to_f * total_allocation / 100
        end

        def computed_percentage
          model.fetch("vote_threshold_percent", 0).to_f
        end
      end
    end
  end
end
