require 'test_helper'

class CalendarHelperTest < ActionView::TestCase
  setup do
    @original_load_path = I18n.load_path
    I18n.load_path = [Rails.root.join(*%w{test fixtures helpers locale calendar_helper_test.yml})]
  end

  teardown do
    I18n.load_path = @original_load_path
    I18n.reload!
  end

  test "has_t should return false if a translation key does not exist" do
    assert ! has_t?("foo")
  end

  test "has_t should return true if a translation key does exist" do
    assert has_t?("test")
  end
end