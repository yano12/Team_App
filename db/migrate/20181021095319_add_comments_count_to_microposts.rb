class AddCommentsCountToMicroposts < ActiveRecord::Migration[5.1]
  def self.up
    add_column :microposts, :comments_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :microposts, :comments_count
  end
end
