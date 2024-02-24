# frozen_string_literal: true
module Decidim::BudgetCategoryVoting::Overrides

  module Order
    extend ActiveSupport::Concern

    included do

      with_options if: :category_voting_rule? do
        # Rules active for the budget threshold and minimum budgets rules.
      end

      # Public: Returns true if the project voting rule is enabled
      def category_voting_rule?
        return unless budget

        budget.settings.vote_rule_category_voting_enabled
      end

      def minimum_projects_for_category(category_hash)
        return minimum_projects unless category_voting_rule?

        case category_hash["criteria"]
        when "vote_rule_threshold_percent_enabled"
          category_hash["percentage"].to_i
        when "vote_rule_minimum_budget_projects_enabled"
          category_hash["projects_number"].to_i
        when "vote_rule_selected_projects_enabled"
          category_hash["minimum"].to_i
        else
          0
        end
      end

      def maximum_projects_for_category(category_hash)
        return maximum_projects unless category_voting_rule?

        case category_hash["criteria"]
        when "vote_rule_minimum_budget_projects_enabled"
          category_hash["projects_number"].to_i
        when "vote_rule_selected_projects_enabled"
          category_hash["maximum"].to_i
        else
          0
        end
      end
    end
  end
end
