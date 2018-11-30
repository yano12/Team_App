class TeamsController < ApplicationController
  before_action :logged_in_player,  only: [:edit, :update, :destroy, :following, :followers, :calendar]
  before_action :manager_player,    only: [:edit, :update, :destroy]
  before_action :correct_team,      only: [:edit, :update, :destroy]
  
  def team_stats 
    @team = Team.find(params[:id])
    @players = @team.players
  end
  
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
    @teams = Team.paginate(page: params[:page], per_page: 40).search(params[:search])
  end
  
  def edit
    @team = Team.find(params[:id])
  end
  
  def update
    @team = Team.find(params[:id])
    if @team.update_attributes(team_params)
      flash[:success] = "チームプロフィールを更新しました"
      redirect_to @team
    else
      render 'edit'
    end
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
  
  def calendar
    @team = Team.find(params[:id])
    render 'calendar/index'
  end
  
  def team_stats
    @team = Team.find(params[:id])
    @players = @team.players.where(activated: true)
  end
  
  private
  
    def team_params
      params.require(:team).permit(:name, :password,:password_confirmation)
    end
    
    # beforeアクション
    
    # 正しいチームかどうか確認
    def correct_team
      @team = Team.find(params[:id])
      redirect_to(root_url) unless current_team?(@team)
    end
    
    
    # チーム管理者ならtrueを返す
    def team_manager?(player)
      ActiveRecord::Type::Boolean.new.cast(player[:team_manager])
    end
    
    # チーム管理者かどうか確認
    def manager_player
      redirect_to(edit_player_path(current_player)) unless team_manager?(current_player)
    end
end