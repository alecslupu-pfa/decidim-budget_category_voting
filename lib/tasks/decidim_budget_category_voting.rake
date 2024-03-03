# frozen_string_literal: true

namespace :decidim_budget_category_voting do
  task :choose_target_plugins do
    ENV["FROM"] += "#{ENV.fetch("FROM", nil)},decidim_budget_category_voting"
  end
end

Rake::Task["decidim:choose_target_plugins"].enhance do
  Rake::Task["decidim_budget_category_voting:choose_target_plugins"].invoke
end
