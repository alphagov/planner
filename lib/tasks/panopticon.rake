namespace :panopticon do
  task :panopticon_environment do
    require 'logger'
    @logger = Logger.new STDERR
    @logger.level = Logger::INFO

    require 'gds_api/panopticon'
    platform = ENV['FACTER_govuk_platform'] || 'development'
    GdsApi::Base.logger = @logger
    @panopticon = GdsApi::Panopticon.new platform, timeout: 5
  end

  desc "Register application metadata with panopticon"
  task :register => [:panopticon_environment, :environment] do
    @logger.info "Registering with panopticon..."
    ::Plan.all.each do |planner|
      @logger.info "Checking #{planner.slug}"
      existing = @panopticon.artefact_for_slug(planner.slug)
      if ! existing
        @logger.info "Creating #{planner.slug}"
        @panopticon.create_artefact(slug: planner.slug, owning_app: "planner", kind: "custom-application", name: planner.title)
      elsif existing.owning_app == "planner"
        @logger.info "Updating #{planner.slug}"
        @panopticon.update_artefact(planner.slug, owning_app: "planner", kind: "custom-application", name: planner.title)
      else
        raise "Slug #{planner.slug} already registered to application '#{existing.owning_app}'"
      end 
    end
  end
end