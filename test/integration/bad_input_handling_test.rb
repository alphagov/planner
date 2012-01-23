require 'integration_test_helper'

class BadInputHandlingTest < ActionDispatch::IntegrationTest
  test "should quickly return 500 if bad encodings in user input" do
    get "/maternity?wsdl=/..%c0%af../..%c0%af../..%c0%af../..%c0%af../etc/passwd"
    assert_equal 500, response.code.to_i
  end
end
