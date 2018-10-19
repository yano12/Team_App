class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "Team"
  belongs_to :followed, class_name: "Team"
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
