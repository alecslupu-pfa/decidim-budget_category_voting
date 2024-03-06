# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    module Rules
      class GenericRule
        def initialize(model, current_order)
          @model = model
          @current_order = current_order
        end

        def remaining_votes = 0

        def caption = ""

        def total_allocation = current_order.total

        def current_allocation = 0

        protected

        attr_reader :model, :current_order
      end
    end
  end
end
