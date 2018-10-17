class AddActivationToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :activation_digest, :string
    add_column :players, :activated, :boolean, default: false
    add_column :players, :activated_at, :datetime
  end
end
