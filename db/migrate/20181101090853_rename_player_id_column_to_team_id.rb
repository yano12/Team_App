class RenamePlayerIdColumnToTeamId < ActiveRecord::Migration[5.1]
  def change
    rename_column :events, :player_id, :team_id
  end
end
