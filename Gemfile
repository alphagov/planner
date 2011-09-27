source 'http://rubygems.org'

gem 'rails', '3.1.0'
gem 'json'
gem 'jquery-rails'
gem 'compass', '~> 0.12.alpha.0'

if ENV['SLIMMER_DEV']
  gem 'slimmer', :path => '../slimmer'
else
  gem 'slimmer', :git => 'git@github.com:alphagov/slimmer.git'
end

group :mac_development do
  gem 'guard'
  gem 'guard-test'
  gem 'growl_notify'
  gem 'rb-fsevent'
  gem 'ruby-prof'
end

group :test do
  gem 'factory_girl_rails'
  gem 'mocha', :require => false
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
  gem 'webmock', :require => false
  gem 'ci_reporter'
  gem 'test-unit'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end
