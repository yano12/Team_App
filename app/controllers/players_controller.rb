class PlayersController < ApplicationController
  before_action :logged_in_player, only: [:edit, :update, :destroy, :message, :message_show, :edit_stats, :update_stats]
  before_action :correct_player,   only: [:edit, :update, :edit_stats, :update_stats]
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
    @player.game_count = @player.game_count + 1
    @player.play_time += params[:player][:play_time].to_i
    @player.fgm += params[:player][:fgm].to_i
    @player.fga += params[:player][:fga].to_i
    @player.three_m += params[:player][:three_m].to_i
    @player.three_a += params[:player][:three_a].to_i
    @player.ftm += params[:player][:ftm].to_i
    @player.fta += params[:player][:fta].to_i
    @player.ofr += params[:player][:ofr].to_i
    @player.dfr += params[:player][:dfr].to_i
    @player.assist += params[:player][:assist].to_i
    @player.tover += params[:player][:tover].to_i
    @player.steal += params[:player][:steal].to_i
    @player.blockshot += params[:player][:blockshot].to_i
    @player.foul += params[:player][:foul].to_i
    @player.minpg = @player.play_time.to_f / @player.game_count.to_f
    @player.fgpg = @player.fgm.to_f / @player.fga.to_f * 100.0 unless @player.fga == 0
    @player.threepg = @player.three_m.to_f / @player.three_a.to_f * 100.0 unless @player.three_a == 0
    @player.ftpg = @player.ftm.to_f / @player.fta.to_f * 100.0 unless @player.fta == 0
    @player.pts = (1 * @player.ftm) + (2 * @player.fgm) + (3 * @player.three_m)
    @player.ppg = @player.pts.to_f / @player.game_count.to_f
    @player.tor = @player.ofr.to_f + @player.dfr.to_f
    @player.rpg = @player.tor.to_f / @player.game_count.to_f
    @player.apg = @player.assist.to_f / @player.game_count.to_f
    @player.stpg = @player.steal.to_f / @player.game_count.to_f
    @player.bspg = @player.blockshot.to_f / @player.game_count.to_f
    if @player.save
      flash[:success] = "スタッツを更新しました。"
      redirect_to @player
    else
      render 'player_stats'
    end
  end
  
  def show
    @player = Player.find(params[:id])
    @team = @player.team
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
                                   :grade, :old_school, :follow_notification)
    end
    
    def stats_params
      params.require(:player).permit(:game_count, :play_time, :minpg, :pts, :ppg,
                                     :fgm, :fga, :fgpg, :three_m, :three_a, :threepg,
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
