# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    class RuleCell < Decidim::ViewModel
      def show
        render if model.present?
      end

      protected

      delegate :current_participatory_space, :current_order, to: :controller
      delegate :minimum_projects_rule?, :projects_rule?, to: :current_order

      delegate :remaining_votes, :caption, :total_allocation, :current_allocation, to: :rule

      def rule
        return Decidim::BudgetCategoryVoting::Rules::MinimumProjectsRule.new(model, current_order) if minimum_projects_rule?
        return Decidim::BudgetCategoryVoting::Rules::ProjectsRule.new(model, current_order) if projects_rule?

        Decidim::BudgetCategoryVoting::Rules::PercentageRule.new(model, current_order)
      end

      def available_styles
        return "" unless category.respond_to?(:text_color)

        "color: #{category.text_color}; background-color: #{category.background_color};"
      end

      def title
        translated_attribute(category.name)
      end

      def category
        @category ||= current_participatory_space.categories.find(model.fetch("decidim_category_id"))
      end

      def data
        {
          category: category.id,
          total_allocation: total_allocation,
          current_allocation: current_allocation
        }
      end
    end
  end
end
