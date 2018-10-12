class Team < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100 }, uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
