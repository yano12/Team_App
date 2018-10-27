class RelationshipMailer < ApplicationMailer
  
  def follow_notification(team, follower, players)
    @team = team
    @follower = follower
    mail to: players.map{|u| u.email if u.follow_notification == true}, 
    subject: "#{@follower.name} started following your team"
  end

  def unfollow_notification(team, follower, players)
    @team = team
    @follower = follower
    mail to: players.map{|u| u.email if u.follow_notification == true},
    subject: "#{@follower.name} unfollowed your team"
  end
end
