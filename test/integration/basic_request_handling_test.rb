require 'integration_test_helper'

class BasicRequestHandlingTest < ActionDispatch::IntegrationTest
  test "retrieving JSON version without necessary params returns a 400" do
    get "/maternity.json?postcode=12345"
    assert_equal 400, response.code.to_i
  end

  test "retrieving JSON version with necessary params works" do
    get "/maternity.json?due_date%5Bday%5D=24&due_date%5Bmonth%5D=10&due_date%5Byear%5D=2012&start%5Bdays_before_due%5D=14"
    assert_equal 200, response.code.to_i
    assert JSON.parse(response.body)
  end
end
