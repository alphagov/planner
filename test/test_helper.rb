ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'simplecov'
require 'simplecov-rcov'
SimpleCov.start 'rails'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter

module AssertNotPresent
  
  # This is a work-around as assert_select with count:0 seems to be broken.
  # Seems that there's a problem with how assert_select passes the message through to assert as an instance of 
  # AssertionMessage, wheras in test-unit 2.2 checks were added to assert insisting that the message would be a proc
  # or a string. Needs to be investigated/bug report filed
  # suggest adding a unit test in actionpack/test/controller/assert_select_test.rb
  def assert_not_present(selector, pattern)
    css_select(selector).each do |node|
      assert_no_match pattern, node.to_s, "Unexpectedly found a node matching selector #{selector} and pattern #{pattern}"
    end
  end

end