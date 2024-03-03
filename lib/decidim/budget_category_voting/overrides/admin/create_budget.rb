# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    module Overrides
      module Admin
        module CreateBudget
          def create_budget!
            attributes = {
              component: form.current_component,
              scope: form.scope,
              title: form.title,
              weight: form.weight,
              description: form.description,
              total_budget: form.total_budget,
              category_budget_rules: form.category_budget_rules
            }

            @budget = Decidim.traceability.create!(
              Budget,
              form.current_user,
              attributes,
              visibility: "all"
            )
          end
        end
      end
    end
  end
end
