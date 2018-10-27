# Preview all emails at http://localhost:3000/rails/mailers/relationship_mailer
class RelationshipMailerPreview < ActionMailer::Preview
  
  def follow_notification
    team = Team.first
    players = team.players
    follower = Team.second
    RelationshipMailer.follow_notification(team, follower, players)
  end

  def unfollow_notification
    team = Team.first
    players = team.players
    follower = Team.second
    RelationshipMailer.unfollow_notification(team, follower, players)
  end
end
