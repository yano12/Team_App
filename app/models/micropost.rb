class Micropost < ApplicationRecord
  belongs_to :player
  has_many :comments, dependent: :delete_all
  belongs_to :team
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  before_validation :set_in_reply_to
  validates :player_id, presence: true
  validates :content, presence: true, length: { maximum: 255 }
  validates :in_reply_to, presence: false
  validate  :picture_size, :reply_to_player
  
  def Micropost.including_replies_name(name)
    where(in_reply_to: [name, ""]).or(Micropost.where(team_name: name))
    # in_reply_toが""じゃなくてnilだと上手くいかない(フォロワーの投稿が表示されない)
  end
  
  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
    
    # before
    
    def set_in_reply_to
      if content.include?("@") && content.index("@") == 0
        @index = content.index("@")
        reply_name = []
        until content[@index+1].blank? do
          @index += 1
          reply_name << content[@index]
        end
        self.in_reply_to = reply_name.join
      else
        self.in_reply_to = ""
      end
    end

    def reply_to_player
      return if self.in_reply_to == "" # 1
      unless Team.find_by(name: self.in_reply_to) # 2
        errors.add(:base, "チームが存在しません。")
      else
        if team_name == self.in_reply_to # 3
          errors.add(:base, "自分のチームには返信できません。")
        end
      end
    end
end
