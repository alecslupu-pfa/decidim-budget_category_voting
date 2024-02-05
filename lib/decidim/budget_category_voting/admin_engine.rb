# frozen_string_literal: true

module Decidim
  module BudgetCategoryVoting
    # This is the engine that runs on the public interface of `BudgetCategoryVoting`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::BudgetCategoryVoting::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :budget_category_voting do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "budget_category_voting#index"
      end

      def load_seed
        nil
      end
    end
  end
end
