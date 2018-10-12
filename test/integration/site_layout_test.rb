require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  test "layout links" do
    get root_path
    assert_template 'top_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", contact_path
    get contact_path
    assert_select "title", full_title("Contact")
    get new_team_path
    assert_template 'teams/new'
    assert_select "title", full_title("Sign up")
  end
end
