class TeamsController < ApplicationController
  
  def show
    @team = Team.find(params[:id])
    @players = @team.players.where(activated: true).paginate(page: params[:page])
  end
  
  def new
    @team = Team.new
  end
  
  def create
    @team = Team.new(team_params)
    if @team.save
      msg = "チームを作成しました。, 続いてプレイヤーアカウントを作成してください"
      msg = msg.gsub(",","<br>")
      team_log_in @team
      flash[:success] = msg.html_safe
      redirect_to signup_path
    else
      render 'new'
    end
  end
  
  def index
    @teams = Team.paginate(page: params[:page]).search(params[:search])
  end
  
  private
  
    def team_params
      params.require(:team).permit(:name, :password,:password_confirmation)
    end
end