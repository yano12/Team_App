require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @player = players(:michael)
    remember(@player)
  end

  test "current_player returns right player when session is nil" do
    assert_equal @player, current_player
    assert is_logged_in?
  end

  test "current_player returns nil when remember digest is wrong" do
    @player.update_attribute(:remember_digest, Player.digest(Player.new_token))
    assert_nil current_player
  end
end