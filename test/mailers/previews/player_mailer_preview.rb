# Preview all emails at http://localhost:3000/rails/mailers/player_mailer
class PlayerMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/player_mailer/account_activation
  def account_activation
    player = Player.first
    player.activation_token = Player.new_token
    PlayerMailer.account_activation(player)
  end

  # Preview this email at http://localhost:3000/rails/mailers/player_mailer/password_reset
  def password_reset
    PlayerMailer.password_reset
  end

end
