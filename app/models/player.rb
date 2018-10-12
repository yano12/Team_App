class Player < ApplicationRecord
  belongs_to :team
  validates :team_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
end
