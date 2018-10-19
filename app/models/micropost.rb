class Micropost < ApplicationRecord
  belongs_to :player
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :player_id, presence: true
  validates :content, presence: true, length: { maximum: 255 }
  validate  :picture_size
  
  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
