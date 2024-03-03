# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    class RuleCell < Decidim::ViewModel

      delegate :current_participatory_space, :current_order, to: :controller

      def show
        # raise model.inspect
        # {"position"=>0, "deleted"=>true, "decidim_category_id"=>5, "vote_threshold_percent"=>nil, "vote_minimum_budget_projects_number"=>nil, "vote_selected_projects_minimum"=>nil, "vote_selected_projects_maximum"=>nil}
        render
      end

      def title
        translated_attribute(category.name)
      end

      def category
        @category ||= current_participatory_space.categories.find(model.fetch("decidim_category_id"))
      end

      def available_styles
        return "" unless category.respond_to?(:text_color)

        "color: #{category.text_color}; background-color: #{category.background_color};"
      end

      def remaining_votes
        return minimum_remaining_votes if current_order.minimum_projects_rule?
        return project_remaining_votes if current_order.projects_rule?

        remaining_percentage
      end

      def remaining_percentage
        # return 0 unless current_order.percentage_rule?

        (
          model.fetch("vote_threshold_percent") -
          (current_order.projects.with_category(category).sum(:budget_amount).to_f / current_order.budget.total_budget) * 100
        ).round(2)
      end

      def project_remaining_votes
        return 0 unless current_order.projects_rule?


        model.fetch("vote_selected_projects_minimum").to_i - current_order.projects.with_category(category).count
      end
      def minimum_remaining_votes
        return 0 unless current_order.minimum_projects_rule?

        model.fetch("vote_minimum_budget_projects_number").to_i - current_order.projects.with_category(category).count
      end

      def label
        return I18n.t("remaining_votes", scope: "decidim.budget_category_voting.rule") if current_order.minimum_projects_rule?
        return I18n.t("remaining_votes", scope: "decidim.budget_category_voting.rule") if current_order.projects_rule?
        I18n.t("remaining_percentage", scope: "decidim.budget_category_voting.rule")
      end
    end
  end
end