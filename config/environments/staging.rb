require File.expand_path('production.rb', File.dirname(__FILE__))
Planner::Application.configure do
  config.middleware.delete(Slimmer::App)
  config.middleware.insert_after Rack::Lock,  Slimmer::App, :template_host => "/data/vhost/static.#{Rails.env}.alphagov.co.uk/current/public/templates"
end