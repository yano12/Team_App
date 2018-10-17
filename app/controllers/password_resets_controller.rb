class PasswordResetsController < ApplicationController
  before_action :get_player,   only: [:edit, :update]
  before_action :valid_player, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end
  
  def create
    @player = Player.find_by(email: params[:password_reset][:email].downcase)
    if @player
      @player.create_reset_digest
      @player.send_password_reset_email
      flash[:info] = "メールを送信しました。"
      redirect_to root_url
    else
      flash.now[:danger] = "メールアドレスが見つかりません。"
      render 'new'
    end
  end

  def edit
  end
  
  def update
    if params[:player][:password].empty?
      @player.errors.add(:password, :blank)
      render 'edit'
    elsif @player.update_attributes(player_params)
      log_in @player
      @player.update_attribute(:reset_digest, nil)
      flash[:success] = "パスワードを更新しました。"
      redirect_to @player
    else
      render 'edit'
    end
  end

  private

    def player_params
      params.require(:player).permit(:password, :password_confirmation)
    end

    def get_player
      @player = Player.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する
    def valid_player
      unless (@player && @player.activated? &&
              @player.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    
    # トークンが期限切れかどうか確認する
    def check_expiration
      if @player.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
