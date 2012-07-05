require "slimmer/headers"

class ApplicationController < ActionController::Base
  include Slimmer::Headers
  before_filter :set_analytics_headers
  protect_from_forgery

  def set_analytics_headers
    set_slimmer_headers(
      section: "family",
      format: "planner",
      proposition: "citizen"
    )
  end
end
