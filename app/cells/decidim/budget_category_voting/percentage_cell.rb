# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    class PercentageCell < OrderCategoryCell
      include ActionView::Helpers::NumberHelper
      include Decidim::Budgets::ProjectsHelper

      delegate :minimum_budget, :total, to: :model

      def caption = t("rule.remaining_budget")

      def current_rule_explanation
        t("vote_threshold_percent_rule.instruction_html", minimum_budget: budget_to_currency(minimum_budget))
      end

      def remaining_votes
        count = minimum_budget - total
        count.positive? ? budget_to_currency(count) : 0
      end
    end
  end
end
