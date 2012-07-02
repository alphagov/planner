require 'test_helper'
require 'capybara/rails'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end

# Tell all requests to skip slimmer
class ActionController::Base
  before_filter proc {
    response.headers[Slimmer::SKIP_HEADER] = "true"
  }
end

Capybara.default_driver = :webkit
Capybara.app = Rack::Builder.new do
  map "/" do
    run Capybara.app
  end
end
