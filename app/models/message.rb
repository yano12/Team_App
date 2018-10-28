class Message < ApplicationRecord
  # form, to というクラスは存在しないのでclass_nameでクラスを指定
  belongs_to :from, class_name: "Player"
  belongs_to :to,   class_name: "Player"
  
  # Scopes
  default_scope -> {order(created_at: :asc)}

  # Validations
  validates :from_id, presence: true
  validates :to_id,   presence: true
  validates :room_id, presence: true
  validates :content, presence: true, length: {maximum: 50}
  
  # Methods
  def Message.recent_in_room(room_id)
    where(room_id: room_id).last(500)
  end
  
  # Callbacks
  after_create_commit { MessageBroadcastJob.perform_later self }
end
