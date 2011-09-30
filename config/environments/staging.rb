require File.expand_path('production.rb', File.dirname(__FILE__))
Planner::Application.configure do
  config.middleware.swap Slimmer::App,  Slimmer::App, :template_host => "/data/vhost/static.#{Rails.env}.alphagov.co.uk/current/public/templates"
end