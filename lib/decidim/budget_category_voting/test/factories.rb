# frozen_string_literal: true

require "decidim/core/test/factories"
require "decidim/budgets/test/factories"

FactoryBot.define do

  factory :budget_category_voting, parent: :budget do
    trait :with_vote_threshold_percent do
      transient do
        vote_threshold_percent { 20 }
      end
      component { create(:budgets_component, :with_vote_threshold_percent) }
      category_budget_rules {
        [
          position: 0,
          decidim_category_id: create(:category).id,
          vote_threshold_percent: 20
        ]
      }
    end

    trait :with_minimum_budget_projects do
      transient do
        selected { 2 }
      end
      component { create(:budgets_component, :with_minimum_budget_projects) }
      category_budget_rules {
        [
          position: 0,
          decidim_category_id: create(:category).id,
          vote_minimum_budget_projects_number: selected
        ]
      }
    end

    trait :with_budget_projects_range do
      transient do
        min { 0 }
        max { 2 }
      end
      component { create(:budgets_component, :with_budget_projects_range) }
      category_budget_rules {
        [
          position: 0,
          decidim_category_id: create(:category).id,
          vote_selected_projects_minimum: min,
          vote_selected_projects_maximum: max
        ]
      }
    end
  end
end
