require 'test_helper'

class TeamsSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    @team = teams(:suns)
  end
  
  test "invalid signup information" do
    get new_team_path
    assert_no_difference 'Team.count' do
      post teams_path, params: { team: { name:  "",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'teams/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger'
  end
  
  test "valid signup information with admin" do
    get new_team_path
    assert_difference 'Team.count', 1 do
      post teams_path, params: { team: { name:  "Example Team",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'players/new'
    assert_not flash.empty?
    post team_login_path, params: { team_session: { name: @team.name,
                                                    password: 'password' } }
    assert_redirected_to signup_path
    follow_redirect!
    assert_template 'players/new'
    assert_difference 'Player.count', 1 do
      post signup_path, params: { player: { team_manager: true,
                                         name:  "Example Player",
                                         email: "player@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    player = assigns(:player)
    assert player.team_manager?
  end
end
