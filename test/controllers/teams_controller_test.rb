require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_team_path
    assert_response :success
  end

end
