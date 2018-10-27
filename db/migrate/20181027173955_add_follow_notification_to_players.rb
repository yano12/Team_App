class AddFollowNotificationToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :follow_notification, :boolean, default:false
  end
end
