# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    class MinimumProjectCell < OrderCategoryCell
      delegate :minimum_projects, :total, to: :model

      def caption = t("rule.remaining_votes")

      def current_rule_explanation
        t("minimum_projects_rule.instruction_html", minimum_number: minimum_projects)
      end

      def remaining_votes
        count = minimum_projects - total
        count >= 0 ? count : 0
      end
    end
  end
end
