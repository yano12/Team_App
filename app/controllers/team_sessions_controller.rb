class TeamSessionsController < ApplicationController
  def new
  end

  def create
    @team = Team.find_by(name: params[:team_session][:name])
    if @team && @team.authenticate(params[:team_session][:password])
      team_log_in @team
      flash[:success] = "続いてプレイヤーを作成してください。"
      redirect_to signup_path
    else
      flash.now[:danger] = "入力内容が間違っています。"
      render 'team_sessions/new'
    end
  end

  def destroy
    # log_out if logged_in?
    # redirect_to root_url
  end
end
