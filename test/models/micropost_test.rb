require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  
  def setup
    @player = players(:michael)
    @micropost = @player.microposts.build(content: "Lorem ipsum", team_id: @player.team_id)
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "player id should be present" do
    @micropost.player_id = nil
    assert_not @micropost.valid?
  end
  
  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 256
    assert_not @micropost.valid?
  end
  
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
