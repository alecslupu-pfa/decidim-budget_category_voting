# frozen_string_literal: true

require "decidim/budget_category_voting/admin"
require "decidim/budget_category_voting/engine"
require "decidim/budget_category_voting/admin_engine"
require "decidim/budget_category_voting/workflows"

module Decidim
  # This namespace holds the logic of the `BudgetCategoryVoting` component. This component
  # allows users to create budget_category_voting in a participatory space.
  module BudgetCategoryVoting
    module Overrides
      autoload :SettingsHelper, "decidim/budget_category_voting/overrides/settings_helper"
      autoload :ComponentForm, "decidim/budget_category_voting/overrides/component_form"
      autoload :ProjectsHelper, "decidim/budget_category_voting/overrides/projects_helper"
      autoload :Order, "decidim/budget_category_voting/overrides/order"
    end
  end
end
