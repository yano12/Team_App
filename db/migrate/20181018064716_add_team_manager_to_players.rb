class AddTeamManagerToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :team_manager, :boolean, default: false
  end
end
