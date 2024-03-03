# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/budget_category_voting/version"

Gem::Specification.new do |s|
  s.version = Decidim::BudgetCategoryVoting.version
  s.authors = ["Alexandru Emil Lupu"]
  s.email = ["contact@alecslupu.ro"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/alecslupu-pfa/decidim-budget_category_voting"
  s.required_ruby_version = ">= 3.0"

  s.name = "decidim-budget_category_voting"
  s.summary = "A decidim budget_category_voting module"
  s.description = "A Decidim module that permits assigning votes per category in budgets."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::BudgetCategoryVoting.version
  s.add_dependency "decidim-admin", Decidim::BudgetCategoryVoting.version
  s.add_dependency "decidim-budgets", Decidim::BudgetCategoryVoting.version
  s.add_dependency "deface", ">= 1.9"

  s.add_development_dependency "decidim-dev", Decidim::BudgetCategoryVoting.version
end
