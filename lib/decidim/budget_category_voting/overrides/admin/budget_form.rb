# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    module Overrides
      module Admin
        module BudgetForm
          def self.prepended(base)
            base.class_eval do
              include Decidim::BudgetCategoryVoting::Admin::HasBudgetCategoryVoting

              attribute :category_budget_rules, Array[Decidim::BudgetCategoryVoting::Admin::CategoryBudgetRuleForm]

              validate :category_budget_rules_validator

              protected
              delegate :settings, to: :current_component

            end
          end
        end
      end
    end
  end
end
