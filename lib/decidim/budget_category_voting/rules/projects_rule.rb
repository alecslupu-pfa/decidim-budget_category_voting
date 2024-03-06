# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    module Rules
      class ProjectsRule < GenericRule
        def caption = I18n.t("available_votes", scope: "decidim.budget_category_voting.rule")

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
