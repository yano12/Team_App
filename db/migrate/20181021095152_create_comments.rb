class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string :content
      t.references :player, foreign_key: true
      t.references :micropost, foreign_key: true
      t.references :parent, foreign_key: true
      t.integer :replies_count

      t.timestamps
    end
  end
end
