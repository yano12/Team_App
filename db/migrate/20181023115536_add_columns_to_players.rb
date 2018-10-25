class AddColumnsToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :number, :integer
    add_column :players, :position, :string
    add_column :players, :height, :float
    add_column :players, :weight, :float
    add_column :players, :grade, :integer
    add_column :players, :old_school, :string
  end
end
