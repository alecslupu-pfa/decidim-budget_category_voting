# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    module CategoryOrder
      class MinimumProject < Base
        def card_class = "decidim/budget_category_voting/minimum_project"

        def total = projects.count

        def can_checkout? = total >= minimum_projects

        def minimum_projects = rule.fetch(:vote_minimum_budget_projects_number, 0).to_i
      end
    end
  end
end
