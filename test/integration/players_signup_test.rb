require 'test_helper'

class PlayersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    @team = teams(:suns)
    ActionMailer::Base.deliveries.clear
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
  
  test "valid signup information with account activation" do
    get team_login_path
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
    assert_equal 1, ActionMailer::Base.deliveries.size
    player = assigns(:player)
    assert_not player.activated?
    # 有効化していない状態でログインしてみる
    log_in_as(player)
    assert_not is_logged_in?
    # 有効化トークンが不正な場合
    get edit_account_activation_path("invalid token", email: player.email)
    assert_not is_logged_in?
    # トークンは正しいがメールアドレスが無効な場合
    get edit_account_activation_path(player.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # 有効化トークンが正しい場合
    get edit_account_activation_path(player.activation_token, email: player.email)
    assert player.reload.activated?
    follow_redirect!
    assert_template 'top_pages/home'
    assert_not flash.empty?
  end
end
