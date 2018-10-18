require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @manager     = players(:michael)
    @not_manager = players(:archer)
  end
  
  test "should get new" do
    get new_team_path
    assert_response :success
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Team.count' do
      delete team_path(@not_manager.team)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@not_manager)
    assert_no_difference 'Team.count' do
      delete team_path(@not_manager.team)
    end
    assert_redirected_to root_url
  end

end
