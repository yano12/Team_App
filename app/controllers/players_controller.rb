class PlayersController < ApplicationController
  before_action :logged_in_player, only: [:edit, :update, :destroy, :message, :message_show]
  before_action :correct_player,   only: [:edit, :update]
  #before_action :admin_player,     only: :destroy
  
  def index
    @players = Player.all.paginate(page: params[:page])
  end
  
  def message
    @feed_players = current_player.feed_player.paginate(page: params[:page]).search(params[:search])
  end
  
  def message_show 
    @player = Player.find(params[:id])
    @room_id = message_room_id(current_player, @player) if logged_in? #ログインしてないとcurrent_playerはnil
    @messages = Message.recent_in_room(@room_id)  #新規メッセージを最大500件取得
    redirect_to root_url and return unless @player.activated?
  end
  
  def edit_stats
    @player = Player.find(params[:id])
  end
  
  def update_stats
    @player = Player.find(params[:id])
    @player.game_count += 1
    @player.play_time += params[:play_time]
    @player.pts += params[:pts]
    @player.three_m += params[:three_m]
    @player.three_a += params[:three_a]
    @player.ftm += params[:ftm]
    @player.fta += params[:fta]
    @player.ofr += params[:ofr]
    @player.dfr += params[:dfr]
    @player.assist += params[:assist]
    @player.tover += params[:tover]
    @player.steal += params[:steal]
    @player.blockshot += params[:blockshot]
    @player.foul += params[:foul]
    
    if logged_in?
      if @player.save
        flash[:success] = "スタッツを更新しました。"
        redirect_to @player
      else
        render 'player_stats'
      end
    else
      render login_url
    end
  end
  
  def show
    @player = Player.find(params[:id])
    @team = @player.team
    @microposts = @player.microposts.paginate(page: params[:page])
    # メッセージ機能の変数定義
    #@room_id = message_room_id(current_player, @player) if logged_in? #ログインしてないとcurrent_playerはnil
    #@messages = Message.recent_in_room(@room_id)  #新規メッセージを最大500件取得
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
                                   :password_confirmation,
                                   :number, :position, :height, :weight,
                                   :grade, :old_school, :follow_notification,
                                   :game_count, :play_time, :minpg, :pts, :ppg,
                                   :fgpg, :three_m, :three_a, :threepg,
                                   :ftm, :fta, :ftpg, :ofr, :dfr, :tor, :rpg,
                                   :assist, :apg, :tover, :steal, :stpg,
                                   :blockshot, :bspg, :foul)
    end
    
    def message_room_id(first_player, second_player)
      first_id = first_player.id.to_i
      second_id = second_player.id.to_i
      # ルームIDはハイフンで両者のIDを連結したもの
      if first_id < second_id
        "#{first_player.id}-#{second_player.id}"
      else
        "#{second_player.id}-#{first_player.id}"
      end
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
