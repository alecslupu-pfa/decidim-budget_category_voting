# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    class MinimumProjectCell < OrderCategoryCell
      delegate :minimum_projects, :total, to: :model

      def inline_criteria
        t("minimum_projects_rule.inline_criteria_html", minimum_number: minimum_projects)
      end

      def current_rule_explanation
        t("minimum_projects_rule.instruction_html", minimum_number: minimum_projects)
      end
    end
  end
end
