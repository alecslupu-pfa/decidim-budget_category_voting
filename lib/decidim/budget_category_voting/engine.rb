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

      initializer "budget_category_voting.overrides", after: "decidim.action_controller" do
        config.to_prepare do
          ActiveSupport.on_load :action_controller do
            Decidim::Budgets::Order.prepend Decidim::BudgetCategoryVoting::Overrides::Order

            Decidim::Budgets::Admin::BudgetsController.prepend Decidim::BudgetCategoryVoting::Overrides::Admin::BudgetsController
            Decidim::Budgets::Admin::BudgetForm.prepend Decidim::BudgetCategoryVoting::Overrides::Admin::BudgetForm
            Decidim::Budgets::Admin::CreateBudget.prepend Decidim::BudgetCategoryVoting::Overrides::Admin::CreateBudget
            Decidim::Budgets::Admin::UpdateBudget.prepend Decidim::BudgetCategoryVoting::Overrides::Admin::UpdateBudget
          end
        end
      end

      initializer "budget_category_voting.views" do
        Rails.application.configure do
          config.deface.enabled = Decidim::BudgetCategoryVoting.deface_enabled
        end
      end

      initializer "budget_category_voting.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      initializer "budget_category_voting.categories" do
        Rails.application.configure do
          Decidim::CategoryEnhanced.coloured_labels = true if defined? Decidim::CategoryEnhanced
        end
      end

      initializer "budget_category_voting.add_cells_view_paths", before: "decidim_budgets.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::BudgetCategoryVoting::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::BudgetCategoryVoting::Engine.root}/app/views") # for partials
      end
    end
  end
end
