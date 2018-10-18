class PlayersController < ApplicationController
  before_action :logged_in_player, only: [:index, :edit, :update, :destroy]
  before_action :correct_player,   only: [:edit, :update]
  before_action :admin_player,     only: :destroy
  
  def show
    @player = Player.find(params[:id])
    redirect_to root_url and return unless @player.activated?
  end
  
  def new
    @player = Player.new
  end
  
  def create
    @player = current_team.players.build(player_params)
    if @player.save
      @player.send_activation_email
      flash[:info] = "アカウント有効化メールを送信しました。"
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
    @player = Player.find(params[:id])
  end 
  
  def update
    @player = Player.find(params[:id])
    if @player.update_attributes(player_params)
      flash[:success] = "プロフィールを更新しました"
      redirect_to @player
    else
      render 'edit'
    end
  end
  
  def destroy
    Player.find(params[:id]).destroy
    flash[:success] = "プレイヤーを削除しました"
    redirect_to root_url
  end

  private

    def player_params
      params.require(:player).permit(:team_manager, :name, :email, :password,
                                   :password_confirmation)
    end
    
    # beforeアクション
    
    # ログイン済みプレイヤーかどうか確認
    def logged_in_player
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    # 正しいユーザーかどうか確認
    def correct_player
      @player = Player.find(params[:id])
      redirect_to(root_url) unless current_player?(@player)
    end
    
    # 管理者かどうか確認
    def admin_player
      redirect_to(root_url) unless current_player.admin?
    end
end
