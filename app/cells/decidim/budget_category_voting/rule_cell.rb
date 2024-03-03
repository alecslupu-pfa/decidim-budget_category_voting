# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    class RuleCell < Decidim::ViewModel
      def show
        render
      end

      protected

      delegate :current_participatory_space, :current_order, to: :controller
      delegate :minimum_projects_rule?, :projects, to: :current_order

      def available_styles
        return "" unless category.respond_to?(:text_color)

        "color: #{category.text_color}; background-color: #{category.background_color};"
      end

      def title
        translated_attribute(category.name)
      end

      def remaining_votes
        return minimum_remaining_votes if current_order.minimum_projects_rule?

        raise "Unknown order type:"
      end

      def label
        return I18n.t("remaining_votes", scope: "decidim.budget_category_voting.rule") if minimum_projects_rule?

        raise "Unknown order type:"
      end

      def category
        @category ||= current_participatory_space.categories.find(model.fetch("decidim_category_id"))
      end

      def minimum_remaining_votes
        return 0 unless minimum_projects_rule?

        model.fetch("vote_minimum_budget_projects_number", 0).to_i - projects.with_category(category).count
      end
    end
  end
end