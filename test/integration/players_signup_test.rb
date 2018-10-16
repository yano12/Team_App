require 'test_helper'

class PlayersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    @team = teams(:suns)
  end
  
  test "invalid team login information" do 
    get team_login_path
    assert_template 'team_sessions/new'
    post team_login_path, params: { team_session: { name: "", password: "" } }
    assert_template 'team_sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  test "invalid signup information" do
    get team_login_path
    post team_login_path, params: { team_session: { name: @team.name,
                                                    password: 'password' } }
    assert_redirected_to signup_path
    follow_redirect!
    assert_template 'players/new'
    assert_no_difference 'Player.count' do
      post signup_path, params: { player: { name:  "",
                                         email: "player@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'players/new'
  end
  
  test "valid signup information" do
    get team_login_path
    post team_login_path, params: { team_session: { name: @team.name,
                                                    password: 'password' } }
    assert_redirected_to signup_path
    follow_redirect!
    assert_template 'players/new'
    assert_difference 'Player.count', 1 do
      post signup_path, params: { player: { name:  "Example Player",
                                         email: "player@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'players/show'
    assert_not flash.empty?
  end
end
