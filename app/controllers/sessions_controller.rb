class SessionsController < ApplicationController
  
  def new
  end

  def create
    @player = Player.find_by(email: params[:session][:email].downcase)
    if @player && @player.authenticate(params[:session][:password])
      if @player.activated?
        log_in @player
        params[:session][:remember_me] == '1' ? remember(@player) : forget(@player)
        redirect_back_or root_url
      else
        message  = "アカウントが有効化されていません。"
        message += "アカウント有効化メールを確認してください。"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = "入力内容が間違っています。"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
