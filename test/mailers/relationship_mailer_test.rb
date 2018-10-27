require 'test_helper'

class RelationshipMailerTest < ActionMailer::TestCase
  
  test "follow_notification" do
    team = teams(:spurs)
    follower = teams(:lakers)
    players = team.players
    mail = RelationshipMailer.follow_notification(team, follower, players)
    assert_equal "#{follower.name} started following your team", mail.subject
    #assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match team.name, mail.body.encoded
    assert_match follower.name, mail.body.encoded
  end

  test "unfollow_notification" do
    team = teams(:spurs)
    follower = teams(:lakers)
    players = team.players
    mail = RelationshipMailer.unfollow_notification(team, follower, players)
    assert_equal "#{follower.name} unfollowed your team", mail.subject
    #assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match team.name, mail.body.encoded
    assert_match follower.name, mail.body.encoded
  end
end
