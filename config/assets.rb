# frozen_string_literal: true

base_path = File.expand_path("..", __dir__)

Decidim::Webpacker.register_path("#{base_path}/app/packs", prepend: true)
Decidim::Webpacker.register_entrypoints(
  decidim_budget_category_voting: "#{base_path}/app/packs/entrypoints/decidim_budget_category_voting.js",
  decidim_budget_category_voting_admin: "#{base_path}/app/packs/entrypoints/decidim_budget_category_voting_admin.js"
)
Decidim::Webpacker.register_stylesheet_import("stylesheets/decidim/budget_category_voting/budget_category_voting")
