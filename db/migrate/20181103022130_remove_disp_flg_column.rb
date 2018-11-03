class RemoveDispFlgColumn < ActiveRecord::Migration[5.1]
  def change
    remove_column :events, :disp_flg, :boolean
    remove_column :events, :allDay, :string
  end
end
