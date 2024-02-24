# frozen_string_literal: true

require "decidim/budget_category_voting/admin"
require "decidim/budget_category_voting/engine"
require "decidim/budget_category_voting/admin_engine"

module Decidim
  # This namespace holds the logic of the `BudgetCategoryVoting` component. This component
  # allows users to create budget_category_voting in a participatory space.
  module BudgetCategoryVoting
    include ActiveSupport::Configurable

    config_accessor :deface_enabled do
      ENV.fetch("DEFACE_ENABLED", nil) == "true" || Rails.env.test?
    end

  end
end
