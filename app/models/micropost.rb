class Micropost < ApplicationRecord
  belongs_to :player
  belongs_to :team
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  before_validation :set_in_reply_to
  validates :player_id, presence: true
  validates :content, presence: true, length: { maximum: 255 }
  validates :in_reply_to, presence: false
  validate  :picture_size, :reply_to_player
  
  def Micropost.including_replies(id)
    where(in_reply_to: [id, 0]).or(Micropost.where(team_id: id))
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
      if @index = content.index("@")
        reply_id = []
        while is_i?(content[@index+1])
          @index += 1
          reply_id << content[@index]
        end
        self.in_reply_to = reply_id.join.to_i
      else
        self.in_reply_to = 0
      end
    end

    def is_i?(s)
      Integer(s) != nil rescue false
    end

    def reply_to_player
      return if self.in_reply_to == 0 # 1
      unless player = Player.find_by(id: self.in_reply_to) # 2
        errors.add(:base, "Player ID you specified doesn't exist.")
      else
        if player_id == self.in_reply_to # 3
          errors.add(:base, "You can't reply to yourself.")
        else
          unless reply_to_player_name_correct?(player) # 4
            errors.add(:base, "Player ID doesn't match its name.")
          end
        end
      end
    end

    def reply_to_player_name_correct?(player)
      player_name = player.name.gsub(" ", "-")
      content[@index+2, player_name.length] == player_name
    end
end
