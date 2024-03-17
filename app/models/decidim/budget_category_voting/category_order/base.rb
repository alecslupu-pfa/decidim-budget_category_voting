# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    module CategoryOrder
      class Base
        include ActiveModel::Validations

        def initialize(order, rule)
          @order = order
          @rule = rule.with_indifferent_access
        end

        def category
          @category ||= Decidim::Category.find(rule[:decidim_category_id])
        end

        delegate :id, to: :category
        delegate :checked_out?, :budget, to: :order

        def card_class
          raise "Not implemented"
        end

        def total = projects.sum(:budget_amount).to_f

        def minimum_budget = 0

        def maximum_budget = budget.total_budget.to_f

        def budget_percent
          return 0 if maximum_budget.zero?

          total / maximum_budget * 100
        end

        def available_allocation = maximum_budget

        def allocation_for(project) = project.budget_amount

        protected

        attr_reader :order, :rule

        def projects = order.projects.with_category(category)
      end
    end
  end
end
