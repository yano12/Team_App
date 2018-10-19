require 'test_helper'

class PlayersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @player = players(:michael)
  end

  test "profile display" do
    get player_path(@player)
    assert_template 'players/show'
    assert_select 'title', full_title(@player.name)
    assert_select 'h1', text: @player.name
    assert_select 'h1>img.gravatar'
    assert_match @player.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @player.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
