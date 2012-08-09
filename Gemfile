source 'http://rubygems.org'
source 'https://gems.gemfury.com/vo6ZrmjBQu5szyywDszE/'

gem 'exception_notification'

gem 'rails', '3.2.7'
gem 'json'
gem 'jquery-rails'
gem "ri_cal", "~> 0.8.8"
gem 'gds-api-adapters', '~> 0.1.2'
gem 'gds-warmup-controller'
gem 'aws-ses', require: 'aws/ses'
gem 'gelf'
gem 'unicorn'
gem 'lograge'

if ENV['SLIMMER_DEV']
  gem 'slimmer', path: '../slimmer'
else
  gem 'slimmer', '~> 1.1.42'
end

group :test do
  gem 'factory_girl_rails'
  gem 'mocha', require: false
  gem "shoulda", "~> 2.11.3"
  gem 'simplecov', '0.4.2'
  gem 'simplecov-rcov'
  gem 'webmock', require: false
  gem 'ci_reporter'
  gem 'test-unit'
  # Pretty printed test output
  gem 'turn', require: false
  gem 'capybara'
end

group :assets do
  gem "therubyracer", "~> 0.9.4"
  gem 'uglifier'
end
