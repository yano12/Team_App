require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "Team App"
    assert_equal full_title("Contact"), "Contact | Team App"
  end
end