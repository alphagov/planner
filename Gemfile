source 'http://rubygems.org'
source 'https://gems.gemfury.com/vo6ZrmjBQu5szyywDszE/'

group :router do
  gem 'router-client', '2.0.3', :require => 'router/client'
end

# passenger compatibility
group :passenger_compatibility do
  gem 'rack', '1.3.5'
  gem 'rake', '0.9.2'
end

gem 'exception_notification'

gem 'rails', '3.1.3'
gem 'json'
gem 'jquery-rails'
gem 'compass', '~> 0.12.alpha.0'
gem "ri_cal", "~> 0.8.8"
gem 'rummageable'
gem 'gds-api-adapters', '~> 0.0.15'
gem 'gds-warmup-controller'
gem 'aws-ses', :require => 'aws/ses'
gem 'gelf'

if ENV['SLIMMER_DEV']
  gem 'slimmer', :path => '../slimmer'
else
  gem 'slimmer', '~> 1.1.39'
end

group :test do
  gem 'factory_girl_rails'
  gem 'mocha', :require => false
  gem "shoulda", "~> 2.11.3"
  gem 'simplecov', '0.4.2'
  gem 'simplecov-rcov'
  gem 'webmock', :require => false
  gem 'ci_reporter'
  gem 'test-unit'
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'capybara'
end

group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem "therubyracer", "~> 0.9.4"
  gem 'uglifier'
end
