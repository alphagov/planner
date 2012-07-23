# This file is used by Rack-based servers to start the application.
require 'bundler'
Bundler.require(:default, ENV['GOVUK_ENV'])

require ::File.expand_path('../config/environment',  __FILE__)
run Planner::Application
