require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @player = players(:michael)
  end

  test "micropost interface" do
    log_in_as(@player)
    get root_path
    #assert_select 'div.pagination'
    assert_select 'input[type=file]'
    # 無効な送信
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    # 有効な送信
    content = "This micropost really ties the room together"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost:
                                      { content: content,
                                        picture: picture } }
    end
    assert assigns(:micropost).picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # 投稿を削除する
    assert_select 'a', text: '削除'
    first_micropost = @player.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # 違うユーザーのプロフィールにアクセス (削除リンクがないことを確認)
    get player_path(players(:archer))
    assert_select 'a', text: '削除', count: 0
  end
  
  test "micropost sidebar count" do
    log_in_as(@player)
    get root_path
    assert_match "#{@player.microposts.count}件の投稿", response.body
    # まだマイクロポストを投稿していないユーザー
    other_player = players(:malory)
    log_in_as(other_player)
    get root_path
    assert_match "0件の投稿", response.body
    other_player.microposts.create!(content: "A micropost",
                                    team_id: other_player.team_id)
    get root_path
    assert_match "1件の投稿", response.body
  end
  
  test "reply to other player" do
    other_player = players(:fuga)
    log_in_as(@player)
    get root_path
    # invalid post(チームが存在しません。)
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: {micropost: {content: "@ん 返信"}}
    end
    assert_select 'div#error_explanation'
    # invalid post(自分のチームには返信できません。)
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: {micropost: {content: "@#{@player.team.name}　返信"}}
    end
    assert_select 'div#error_explanation'
    # valid post
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: {micropost: {content: "@#{other_player.team.name} 返信",
                                     team_id: @player.team_id}}
    end
  end
  
  test "reply post visibility" do
    reply_to_player = players(:fuga)
    other_player = players(:piyo)
    log_in_as(@player)
    get root_path
    content = "@#{reply_to_player.team.name} 返信"
    post microposts_path, params: {micropost: {content: content,
                                    team_id: @player.team_id}}
    follow_redirect!
    assert_match content, response.body
    # should be visible
    log_in_as(reply_to_player)
    get root_path
    assert_match content, response.body
    # shouldn't be visible
    log_in_as(other_player)
    get root_path
    assert_no_match content, response.body
  end
end