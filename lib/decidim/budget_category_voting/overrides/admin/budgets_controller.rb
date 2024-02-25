# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    module Overrides
      module Admin
        module BudgetsController
          def self.prepended(base)
            base.class_eval do
              helper_method :blank_category_budget_rule

              private
              def blank_category_budget_rule
                @blank_category_budget_rule ||= form(Decidim::BudgetCategoryVoting::Admin::CategoryBudgetRuleForm).instance
              end
            end
          end
        end
      end
    end
  end
end
