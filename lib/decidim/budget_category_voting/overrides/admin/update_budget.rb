# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    module Overrides
      module Admin
        module UpdateBudget
          def update_budget!
            attributes = {
              scope: form.scope,
              title: form.title,
              weight: form.weight,
              description: form.description,
              total_budget: form.total_budget,
              category_budget_rules: fetch_category_budget_rules
            }

            Decidim.traceability.update!(
              budget,
              form.current_user,
              attributes,
              visibility: "all"
            )
          end


          private
          def fetch_category_budget_rules
            form.category_budget_rules.reject(&:deleted).collect(&:attributes)
          end
        end
      end
    end
  end
end
