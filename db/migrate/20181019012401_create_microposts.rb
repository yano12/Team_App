class CreateMicroposts < ActiveRecord::Migration[5.1]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :player, foreign_key: true

      t.timestamps
    end
    add_index :microposts, [:player_id, :created_at]
  end
end
