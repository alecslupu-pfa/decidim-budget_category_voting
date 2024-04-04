# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    class PercentageCell < OrderCategoryCell
      include ActionView::Helpers::NumberHelper
      include Decidim::Budgets::ProjectsHelper

      delegate :minimum_budget, :total, to: :model

      def inline_criteria
        t("vote_threshold_percent_rule.inline_criteria_html", minimum_budget: budget_to_currency(minimum_budget))
      end

      def current_rule_explanation
        t("vote_threshold_percent_rule.instruction_html", minimum_budget: budget_to_currency(minimum_budget))
      end
    end
  end
end
