# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    module Rules
      class GenericRule
        include ActionView::Helpers::NumberHelper
        def initialize(model, category_name, current_order)
          @model = model
          @current_order = current_order
          @category_name = category_name
        end

        def scope = "decidim.budget_category_voting"

        def t(key, options = {})
          options = { scope: scope, category: category_name }.reverse_merge(options)
          I18n.t(key, **options)
        end

        def current_rule_explanation = ""
        def current_rule_description = ""

        def remaining_votes = 0

        def caption = ""

        def total_allocation = current_order.total

        def current_allocation = 0

        def budget_to_currency(budget)
          number_to_currency budget, unit: Decidim.currency_unit, precision: 0
        end

        protected

        attr_reader :model, :current_order, :category_name
      end
    end
  end
end
