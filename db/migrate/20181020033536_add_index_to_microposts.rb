class AddIndexToMicroposts < ActiveRecord::Migration[5.1]
  def change
    add_reference :microposts, :team, foreign_key: true
  end
end
