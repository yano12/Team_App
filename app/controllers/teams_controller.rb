class TeamsController < ApplicationController
  before_action :logged_in_player,  only: [:destroy, :following, :followers]
  before_action :manager_player,        only: :destroy
  
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
  
  def destroy
    Team.find(params[:id]).destroy
    flash[:success] = "チーム及び所属するプレイヤーを削除しました。"
    redirect_to new_team_path
  end
  
  def following
    @title = "Following"
    @team  = Team.find(params[:id])
    @teams = @team.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @team  = Team.find(params[:id])
    @teams = @team.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  private
  
    def team_params
      params.require(:team).permit(:name, :password,:password_confirmation)
    end
    
    # チーム管理者ならtrueを返す
    def enabled?(player)
      ActiveRecord::Type::Boolean.new.cast(player[:enabled])
    end
    
    # beforeアクション
    
    # チーム管理者かどうか確認
    def manager_player
      redirect_to(root_url) unless enabled?(current_player)
    end
end