require 'test_helper'

class TeamSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get team_login_path
    assert_response :success
  end

end
