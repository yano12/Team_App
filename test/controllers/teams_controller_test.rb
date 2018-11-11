require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @manager     = players(:michael)
    @not_manager = players(:archer)
    @team        = teams(:suns)
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

  test "should redirect destroy when logged in as a non-manager" do
    log_in_as(@not_manager)
    assert_no_difference 'Team.count' do
      delete team_path(@not_manager.team)
    end
    assert_redirected_to edit_player_path(@not_manager)
  end
  
  test "should redirect following when not logged in" do
    get following_team_path(@team)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_team_path(@team)
    assert_redirected_to login_url
  end
end
