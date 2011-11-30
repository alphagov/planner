namespace :router do
  task :router_environment do
    Bundler.require :router, :default

    require 'logger'
    @logger = Logger.new STDOUT
    @logger.level = Logger::DEBUG

    http = Router::HttpClient.new "http://cache.cluster:8080/router", @logger

    @router = Router::Client.new http
  end

  task :register_application => :router_environment do
    platform = ENV['FACTER_govuk_platform']
    url = "planner.#{platform}.alphagov.co.uk/"
    begin
      @logger.info "Registering application..."
      @router.applications.create application_id: "planner", backend_url: url
    rescue Router::Conflict
      application = @router.applications.find "planner"
      puts "Application already registered: #{application.inspect}"
    end
  end

  task :register_routes => [ :router_environment, :environment ] do
    @logger.info "Registering asset path /planner-assets"
    Plan.all_slugs.each do |slug|
      path = "/#{slug}"
      @logger.info "Registering #{path}"
      begin
        @router.routes.create application_id: "planner", route_type: :full,
          incoming_path: path
      rescue => e
        puts [ e.message, e.backtrace ].join("\n")
      end
    end
  end

  desc "Register planner application and routes with the router (run this task on server in cluster)"
  task :register => [ :register_application, :register_routes ]
end

