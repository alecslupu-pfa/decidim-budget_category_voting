# frozen_string_literal: true

Rake::Task["decidim:choose_target_plugins"].enhance do
  Rake::Task["decidim_budget_category_voting:install:migrations"].invoke
end
