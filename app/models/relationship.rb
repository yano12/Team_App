class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "Team"
  belongs_to :followed, class_name: "Team"
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  
  def Relationship.send_follow_email(team, follower, players)
    RelationshipMailer.follow_notification(team, follower, players).deliver_now
  end
  
  def Relationship.send_unfollow_email(team, follower, players)
    RelationshipMailer.unfollow_notification(team, follower, players).deliver_now
  end
end
