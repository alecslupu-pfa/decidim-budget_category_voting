# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    class RuleCell < Decidim::ViewModel
      def show
        render if model.present?
      end

      def rule
        @rule ||= if minimum_projects_rule?
                    Decidim::BudgetCategoryVoting::Rules::MinimumProjectsRule.new(model, title, current_order)
                  elsif projects_rule?
                    Decidim::BudgetCategoryVoting::Rules::ProjectsRule.new(model, title, current_order)
                  else
                    Decidim::BudgetCategoryVoting::Rules::PercentageRule.new(model, title, current_order)
                  end
      end

      protected

      def scope = "decidim.budget_category_voting.budget_excess"

      delegate :current_participatory_space, :current_order, to: :controller
      delegate :minimum_projects_rule?, :projects_rule?, to: :current_order

      delegate :remaining_votes, :caption, :total_allocation, :current_allocation, :current_rule_description, :current_rule_explanation, to: :rule

      def available_styles
        return "" unless category.respond_to?(:text_color)

        "color: #{category.text_color}; background-color: #{category.background_color};"
      end

      def title
        translated_attribute(category.name)
      end

      def popup_title
        t(projects_rule? ? "projects_excess.title_html" : "budget_excess.title_html", scope: scope, category: title)
      end

      def popup_content
        t(projects_rule? ? "projects_excess.description_html" : "budget_excess.description_html", scope: scope, category: title)
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
