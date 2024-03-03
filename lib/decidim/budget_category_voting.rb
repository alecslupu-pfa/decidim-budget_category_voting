# frozen_string_literal: true

require "decidim/budget_category_voting/admin"
require "decidim/budget_category_voting/engine"
require "decidim/budget_category_voting/admin_engine"

module Decidim
  # This namespace holds the logic of the `BudgetCategoryVoting` component. This component
  # allows users to create budget_category_voting in a participatory space.
  module BudgetCategoryVoting
    include ActiveSupport::Configurable

    module Overrides
      module Admin
        autoload :BudgetsController, "decidim/budget_category_voting/overrides/admin/budgets_controller"
        autoload :BudgetForm, "decidim/budget_category_voting/overrides/admin/budget_form"
        autoload :CreateBudget, "decidim/budget_category_voting/overrides/admin/create_budget"
        autoload :UpdateBudget, "decidim/budget_category_voting/overrides/admin/update_budget"
      end
    end

    config_accessor :deface_enabled do
      ENV.fetch("DEFACE_ENABLED", nil) == "true" || Rails.env.test?
    end

  end
end
