class AccountActivationsController < ApplicationController
  
  def edit
    player = Player.find_by(email: params[:email])
    if player && !player.activated? && player.authenticated?(:activation, params[:id])
      player.activate
      log_in player
      flash[:success] = "アカウントを有効化しました。"
      redirect_to root_url
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
