# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    module CategoryOrder
      class Percentage < Base
        def card_class = "decidim/budget_category_voting/percentage"

        def can_checkout? = total.to_f >= minimum_budget

        def minimum_budget = budget.total_budget.to_f * (vote_threshold_percent / 100)

        protected

        def vote_threshold_percent = rule.fetch(:vote_threshold_percent, 0).to_f
      end
    end
  end
end
