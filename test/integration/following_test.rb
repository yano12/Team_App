require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  
  def setup
    @team = teams(:suns)
    @other = teams(:heat)
    @player = players(:michael)
    log_in_as(@player)
  end

  test "following page" do
    get following_team_path(@team)
    assert_not @team.following.empty?
    assert_match @team.following.count.to_s, response.body
    @team.following.each do |team|
      assert_select "a[href=?]", team_path(team)
    end
  end

  test "followers page" do
    get followers_team_path(@team)
    assert_not @team.followers.empty?
    assert_match @team.followers.count.to_s, response.body
    @team.followers.each do |team|
      assert_select "a[href=?]", team_path(team)
    end
  end
  
  test "should follow a team the standard way" do
    assert_difference '@team.following.count', 1 do
      post relationships_path, params: { followed_id: @other.id }
    end
  end

  test "should follow a team with Ajax" do
    assert_difference '@team.following.count', 1 do
      post relationships_path, xhr: true, params: { followed_id: @other.id }
    end
  end

  test "should unfollow a team the standard way" do
    @team.follow(@other)
    relationship = @team.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@team.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "should unfollow a team with Ajax" do
    @team.follow(@other)
    relationship = @team.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@team.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end
end
