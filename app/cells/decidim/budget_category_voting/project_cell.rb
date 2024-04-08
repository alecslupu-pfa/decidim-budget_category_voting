# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    class ProjectCell < OrderCategoryCell
      delegate :maximum_projects, :minimum_projects, :total, :order, to: :model

      def current_rule_explanation
        if minimum_projects.positive? && total < maximum_projects
          t(
            "projects_rule.instruction_html",
            minimum_number: minimum_projects,
            maximum_number: maximum_projects
          )
        else
          t("projects_rule_maximum_only.instruction_html", maximum_number: maximum_projects)
        end
      end

      def inline_criteria
        if minimum_projects.positive? && total < maximum_projects
          t("projects_rule.inline_criteria_html", minimum_number: minimum_projects, maximum_number: maximum_projects)
        else
          t("projects_rule_maximum_only.inline_criteria_html", maximum_number: maximum_projects)
        end
      end
    end
  end
end
