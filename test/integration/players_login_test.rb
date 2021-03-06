require 'test_helper'

class PlayersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @player = players(:michael)
    @team = Team.find_by(id: @player.team_id)
  end
  
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @player.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'top_pages/home'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", edit_player_path(@player)
    # assert_select "a[href=?]", team_path(@team)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", edit_player_path(@player), count: 0
    # assert_select "a[href=?]", team_path(@team), count: 0
  end
  
  test "login with remembering" do
    log_in_as(@player, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:player).remember_token
  end

  test "login without remembering" do
    # クッキーを保存してログイン
    log_in_as(@player, remember_me: '1')
    delete logout_path
    # クッキーを削除してログイン
    log_in_as(@player, remember_me: '0')
    assert_empty cookies['remember_token']
  end
end
