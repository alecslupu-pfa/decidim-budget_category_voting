# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    class OrderCategoryCell < Decidim::ViewModel
      def show
        render if model.present?
      end

      delegate :category, to: :model

      def available_styles
        return "" unless category.respond_to?(:text_color)

        "color: #{category.text_color}; background-color: #{category.background_color};"
      end

      def category_name = translated_attribute(category.name)

      def caption
        raise NotImplementedError
      end

      def popup_title
        t("projects_excess.title_html")
      end

      def popup_content
        t("projects_excess.description_html")
      end

      def data
        {
          category_id: category.id,
          "current-allocation": model.total
          # allocation: model.total_allocation,
        }
      end

      #      def total_allocation = current_order.total

      private

      def scope = "decidim.budget_category_voting"

      def t(key, options = {})
        options = { scope: scope, category: category_name }.reverse_merge(options)
        I18n.t(key, **options)
      end
    end
  end
end
