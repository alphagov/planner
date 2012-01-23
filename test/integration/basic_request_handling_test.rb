require 'integration_test_helper'

class BasicRequestHandlingTest < ActionDispatch::IntegrationTest
  test "retrieving JSON verson (with random param)" do
    get "/maternity.json?postcode=12345"
    assert_equal 200, response.code.to_i
    assert JSON.parse(response.body)
  end
end
