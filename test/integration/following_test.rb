require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  
  def setup
    @team = teams(:suns)
    @other = teams(:heat)
    @players = @other.players
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
    @team.follow(@other, @players)
    relationship = @team.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@team.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "should unfollow a team with Ajax" do
    @team.follow(@other, @players)
    relationship = @team.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@team.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end
  
  test "feed on Home page" do
    get root_path
    @team.feed.paginate(page: 1).each do |micropost|
      assert_match CGI.escapeHTML(micropost.content), response.body
    end
  end
  
  test "should send follow notification email" do
    post relationships_path, params: {followed_id: @other.id}
    assert_equal 1, ActionMailer::Base.deliveries.size
  end

  test "should send unfollow notification email" do
    @team.follow(@other, @players)
    relationship = @team.active_relationships.find_by(followed_id: @other.id)
    delete relationship_path(relationship)
    assert_equal 2, ActionMailer::Base.deliveries.size # follow email and unfollow email
  end
end
