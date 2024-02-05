# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module BudgetCategoryVoting
    # This is the engine that runs on the public interface of budget_category_voting.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::BudgetCategoryVoting

      routes do
        # Add engine routes here
        # resources :budget_category_voting
        # root to: "budget_category_voting#index"
      end

      initializer "BudgetCategoryVoting.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
