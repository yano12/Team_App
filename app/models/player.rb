class Player < ApplicationRecord
  has_many :from_messages, class_name: "Message",
                           foreign_key: "from_id", 
                           dependent: :destroy
  has_many :to_messages, class_name: "Message",
                         foreign_key: "to_id", 
                         dependent: :destroy
  has_many :sent_messages, through: :from_messages, source: :from
  has_many :received_messages, through: :to_messages, source: :to
  has_many :comments
  has_many :microposts, dependent: :destroy
  belongs_to :team
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :team_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }   #大文字と小文字を区別しない
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = Player.new_token
    update_attribute(:remember_digest, Player.digest(remember_token))
  end
  
  # トークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # アカウントを有効にする
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    PlayerMailer.account_activation(self).deliver_now
  end
  
  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = Player.new_token
    update_columns(reset_digest: Player.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    PlayerMailer.password_reset(self).deliver_now
  end
  
  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  # Send message to other player
  def send_message(other_player, room_id, content)
    from_messages.create!(to_id: other_player.id, room_id: room_id, content: content)
  end
  
  # フォローしたチームに所属しているプレイヤーを返す
  def feed_player
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :team_id"
    Player.where("team_id IN (#{following_ids}) OR team_id = :team_id", team_id: team_id)
  end
  
  private

    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email.downcase!
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = Player.new_token
      self.activation_digest = Player.digest(activation_token)
    end
end
