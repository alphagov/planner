source 'http://rubygems.org'
source 'https://gems.gemfury.com/vo6ZrmjBQu5szyywDszE/'

gem 'exception_notification', '2.5.2'

gem 'rails', '3.2.7'
gem 'json', '1.7.4'
gem 'jquery-rails', '1.0.19'
gem 'ri_cal', '0.8.8'
gem 'gds-api-adapters', '0.2.2'
gem 'aws-ses', '0.4.4', require: 'aws/ses'
gem 'gelf', '1.3.2'
gem 'unicorn', '4.3.1'
gem 'lograge', '0.0.6'
gem 'statsd-ruby', '1.0.0'
gem 'rack-statsd', '0.1.1'

if ENV['SLIMMER_DEV']
  gem 'slimmer', path: '../slimmer'
else
  gem 'slimmer', '2.0.0'
end

group :test do
  gem 'factory_girl_rails', '1.4.0'
  gem 'mocha', '0.10.0', require: false
  gem 'shoulda', '2.11.3'
  gem 'simplecov', '0.4.2'
  gem 'simplecov-rcov', '0.2.3'
  gem 'webmock', '1.7.8', require: false
  gem 'ci_reporter', '1.6.5'
  gem 'test-unit', '2.4.2'
  # Pretty printed test output
  gem 'turn', '0.8.3', require: false
  gem 'capybara', '1.1.2'
end

group :assets do
  gem 'therubyracer', '0.10.2'
  gem 'uglifier', '1.1.0'
end
