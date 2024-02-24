# frozen_string_literal: true

require "rails"
require "deface"
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

      initializer "budget_category_voting.views" do
        Rails.application.configure do
          config.deface.enabled = Decidim::BudgetCategoryVoting.deface_enabled
        end
      end

      initializer "budget_category_voting.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
