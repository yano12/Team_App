require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  
  def setup
    @team = Team.new(name: "Example Team",
                     password: "basket", password_confirmation: "basket")
  end

  test "should be valid" do
    assert @team.valid?
  end
  
  test "name should be present" do
    @team.name = "     "
    assert_not @team.valid?
  end
  
  test "name should not be too long" do
    @team.name = "a" * 101
    assert_not @team.valid?
  end
  
  test "name should be unique" do
    duplicate_team = @team.dup
    @team.save
    assert_not duplicate_team.valid?
  end
  
  test "password should be present (nonblank)" do
    @team.password = @team.password_confirmation = " " * 6
    assert_not @team.valid?
  end

  test "password should have a minimum length" do
    @team.password = @team.password_confirmation = "a" * 5
    assert_not @team.valid?
  end
  
  test "associated players should be destroyed" do
    @team.save
    @team.players.create!(name: "kobe", email: "kobe@example.com",
                        password: "password", password_confirmation: "password")
    assert_difference 'Player.count', -1 do
      @team.destroy
    end
  end
  
  test "should follow and unfollow a team" do
    suns = teams(:suns)
    heat  = teams(:heat)
    assert_not suns.following?(heat)
    suns.follow(heat)
    assert suns.following?(heat)
    assert heat.followers.include?(suns)
    suns.unfollow(heat)
    assert_not suns.following?(heat)
  end
  
  test "feed should have the right posts" do
    suns    = teams(:suns)
    heat    = teams(:heat)
    spurs   = teams(:spurs)
    # フォローしているチームの投稿を確認
    spurs.players.each do |following_team_player|
      following_team_player.microposts.each do |post_following|
        assert suns.feed.include?(post_following)
      end
    end
    # 自チームの投稿を確認
    suns.players.each do |player_self|
      player_self.microposts.each do |post_self|
        assert suns.feed.include?(post_self)
      end
    end
    # フォローしていないチームの投稿を確認
    heat.players.each do |unfollowed_team_player|
      unfollowed_team_player.microposts.each do |post_unfollowed|
        assert_not suns.feed.include?(post_unfollowed)
      end
    end
  end
end
