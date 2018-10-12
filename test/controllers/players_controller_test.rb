require 'test_helper'

class PlayersControllerTest < ActionDispatch::IntegrationTest
  
  test "should get new" do 
    get signup_path
    assert_response :success
  end
end
