class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.integer :player_id
      t.string :title
      t.boolean :disp_flg
      t.datetime :start
      t.datetime :end
      t.string :allDay
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
