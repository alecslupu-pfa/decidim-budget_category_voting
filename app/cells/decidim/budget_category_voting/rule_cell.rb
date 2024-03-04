# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    class RuleCell < Decidim::ViewModel
      def show
        render
      end

      protected

      delegate :current_participatory_space, :current_order, to: :controller
      delegate :minimum_projects_rule?, :projects_rule?, :projects, :projects_count_for_rule, to: :current_order

      def available_styles
        return "" unless category.respond_to?(:text_color)

        "color: #{category.text_color}; background-color: #{category.background_color};"
      end

      def title
        translated_attribute(category.name)
      end

      def remaining_votes
        return minimum_projects_number if minimum_projects_rule?
        return minimum_selected_number if projects_rule?

        raise "Unknown order type:"
      end

      def label
        return I18n.t("remaining_votes", scope: "decidim.budget_category_voting.rule") if minimum_projects_rule? || projects_rule?

        raise "Unknown order type:"
      end

      def category
        @category ||= current_participatory_space.categories.find(model.fetch("decidim_category_id"))
      end

      def minimum_projects_number
        @minimum_projects_number ||= begin
          count = model.fetch("vote_minimum_budget_projects_number", 0).to_i - projects_count_for_rule(model)
          count >= 0 ? count : 0
        end
      end

      def minimum_selected_number
        @minimum_selected_number ||= begin
          count = model.fetch("vote_selected_projects_minimum", 0).to_i - projects_count_for_rule(model)
          count >= 0 ? count : 0
        end
      end
    end
  end
end
