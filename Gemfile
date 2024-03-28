# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gem "decidim", "~> 0.27"
gem "decidim-budget_category_voting", path: "."

gem "bootsnap"

group :development, :test do
  gem "decidim-dev", "~> 0.27"
  gem "faker"
  gem "rubocop-performance"
  gem "rubocop-rspec"
  gem "simplecov", require: false
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"
end

group :test do
  gem "rubocop-faker"
end
