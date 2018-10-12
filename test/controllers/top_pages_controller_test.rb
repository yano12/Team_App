require 'test_helper'

class TopPagesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @base_title = "Team App"
  end 
  
  test "should get home" do
    get root_url
    assert_response :success
    assert_select "title", @base_title
  end
  
  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end
end
