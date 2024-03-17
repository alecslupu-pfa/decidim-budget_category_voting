# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    class ProjectCell < OrderCategoryCell
      delegate :maximum_projects, :minimum_projects, :total, to: :model
      def caption = t("rule.available_votes")

      def current_rule_explanation
        if minimum_projects.positive? && total < maximum_projects
          t(
            ".projects_rule.instruction_html",
            minimum_number: minimum_projects,
            maximum_number: maximum_projects
          )
        else
          t(".projects_rule_maximum_only.instruction_html", maximum_number: maximum_projects)
        end
      end

      def remaining_votes
        count = minimum_projects - total
        count >= 0 ? count : 0
      end
    end
  end
end
