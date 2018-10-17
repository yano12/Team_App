require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
    @player = players(:michael)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # メールアドレスが無効
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # メールアドレスが有効
    post password_resets_path,
         params: { password_reset: { email: @player.email } }
    assert_not_equal @player.reset_digest, @player.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # パスワード再設定フォームのテスト
    player = assigns(:player)
    # メールアドレスが無効
    get edit_password_reset_path(player.reset_token, email: "")
    assert_redirected_to root_url
    # 無効なユーザー
    player.toggle!(:activated)
    get edit_password_reset_path(player.reset_token, email: player.email)
    assert_redirected_to root_url
    player.toggle!(:activated)
    # メールアドレスが有効で、トークンが無効
    get edit_password_reset_path('wrong token', email: player.email)
    assert_redirected_to root_url
    # メールアドレスもトークンも有効
    get edit_password_reset_path(player.reset_token, email: player.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", player.email
    # 無効なパスワードとパスワード確認
    patch password_reset_path(player.reset_token),
          params: { email: player.email,
                    player: { password:              "foobaz",
                            password_confirmation: "barquux" } }
    assert_select 'div#error_explanation'
    # パスワードが空
    patch password_reset_path(player.reset_token),
          params: { email: player.email,
                    player: { password:              "",
                            password_confirmation: "" } }
    assert_select 'div#error_explanation'
    # 有効なパスワードとパスワード確認
    patch password_reset_path(player.reset_token),
          params: { email: player.email,
                    player: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
    assert_nil player.reload.reset_digest
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to player
  end
  
  test "expired token" do
    get new_password_reset_path
    post password_resets_path,
         params: { password_reset: { email: @player.email } }

    @player = assigns(:player)
    @player.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@player.reset_token),
          params: { email: @player.email,
                    player: { password:            "foobar",
                            password_confirmation: "foobar" } }
    assert_response :redirect
    follow_redirect!
    assert_match /expired/i, response.body
  end
end
