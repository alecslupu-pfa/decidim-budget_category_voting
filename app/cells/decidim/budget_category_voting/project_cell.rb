# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    class ProjectCell < OrderCategoryCell
      delegate :maximum_projects, :minimum_projects, :total, :order, to: :model
      def caption
        if minimum_projects > total
          t("rule.required_votes")
        else
          t("rule.available_votes")
        end
      end

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

      def remaining_votes
        return minimum_projects if total.zero?
        return minimum_projects - total if minimum_projects > total
        return maximum_projects - total if maximum_projects.positive? && total < maximum_projects

        order.available_allocation - order.total
      end
    end
  end
end
