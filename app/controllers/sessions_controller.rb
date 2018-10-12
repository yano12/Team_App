class SessionsController < ApplicationController
  
  def new
  end

  def create
    @current_team = Team.find_by(id: params[:team_id])
    @player = @current_team.players.build(email: params[:session][:email].downcase)
    if @player && @player.authenticate(params[:session][:password])
      log_in @player
      flash[:info] = "ログインしました"
      redirect_to @player
    else
      flash.now[:danger] = "入力内容が間違っています。"
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
