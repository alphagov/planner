namespace :router do
  task :router_environment do
    Bundler.require :router, :default

    require 'logger'
    @logger = Logger.new STDOUT
    @logger.level = Logger::DEBUG

    @router = Router::Client.new :logger => @logger
  end

  task :register_application => :router_environment do
    platform = ENV['FACTER_govuk_platform']
    url = "planner.#{platform}.alphagov.co.uk/"
    @logger.info "Registering application..."
    @router.applications.update application_id: "planner", backend_url: url
  end

  task :register_routes => [ :router_environment, :environment ] do
    Plan.all_slugs.each do |slug|
      path = "/#{slug}"
      @logger.info "Registering #{path}"
      @router.routes.update application_id: "planner", route_type: :full,
        incoming_path: path
    end
  end

  desc "Register planner application and routes with the router (run this task on server in cluster)"
  task :register => [ :register_application, :register_routes ]
end

