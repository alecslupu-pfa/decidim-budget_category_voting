# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    module CategoryOrder
      class Project < Base
        def card_class = "decidim/budget_category_voting/project"

        def total = projects.count

        def can_checkout? = total >= minimum_projects && total <= maximum_projects

        def budget_percent = total.to_f / maximum_projects * 100

        def available_allocation = maximum_projects

        def allocation_for(_project) = 1

        def minimum_projects = rule.fetch(:vote_selected_projects_minimum, 0).to_i

        def maximum_projects = rule.fetch(:vote_selected_projects_maximum, 0).to_i
      end
    end
  end
end
