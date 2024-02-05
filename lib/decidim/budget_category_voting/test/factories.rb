# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :budget_category_voting_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :budget_category_voting).i18n_name }
    manifest_name :budget_category_voting
    participatory_space { create(:participatory_process, :with_steps) }
  end

  # Add engine factories here
end
