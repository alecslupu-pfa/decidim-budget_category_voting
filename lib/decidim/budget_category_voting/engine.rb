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

      initializer "decidim_budget_category_voting.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      initializer "decidim_budget_category_voting.add_workflow", after: "load_config_initializers" do |app|
        Decidim::Budgets.workflows[:category] = Decidim::BudgetCategoryVoting::Workflows::CategoryVoting
      end

      initializer "decidim_budget_category_voting.patch_engine" do
        config.to_prepare do
          Decidim::Admin::SettingsHelper.prepend(Decidim::BudgetCategoryVoting::Overrides::SettingsHelper)
        end

        Decidim.find_component_manifest(:budgets).settings(:global) do |settings|
          settings.attribute :vote_rule_category_voting_enabled, type: :boolean, default: false
          settings.attribute :vote_category_voting, type: :array
        end
      end
    end
  end
end
