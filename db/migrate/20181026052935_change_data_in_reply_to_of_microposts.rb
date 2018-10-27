class ChangeDataInReplyToOfMicroposts < ActiveRecord::Migration[5.1]
  def change
    remove_column :microposts, :in_reply_to, :integer, default: 0, index: true
  end
end
