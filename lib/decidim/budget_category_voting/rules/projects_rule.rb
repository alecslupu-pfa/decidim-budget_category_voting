# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    module Rules
      class ProjectsRule < GenericRule
        def current_rule_explanation
          if current_order.minimum_projects.positive? && current_allocation < maximum_projects
            t(
              ".projects_rule.instruction_html",
              minimum_number: minimum_projects,
              maximum_number: maximum_projects
            )
          else
            t(".projects_rule_maximum_only.instruction_html", maximum_number: maximum_projects)
          end
        end

        def caption = t("rule.available_votes")

        def minimum_projects = model.fetch("vote_selected_projects_minimum", 0).to_i

        def maximum_projects = model.fetch("vote_selected_projects_maximum", 0).to_i

        alias total_allocation maximum_projects

        def remaining_votes
          count = maximum_projects - current_allocation
          count >= 0 ? count : 0
        end

        def current_allocation
          @current_allocation ||= current_order.projects_count_for_rule(model)
        end
      end
    end
  end
end
