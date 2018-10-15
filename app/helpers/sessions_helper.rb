module SessionsHelper
  
  # 渡されたユーザーでログインする
  def log_in(player)
    session[:player_id] = player.id
  end
  
  # ユーザーのセッションを永続的にする
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # 現在ログイン中のユーザーを返す (いる場合)
  def current_player
    if (player_id = session[:player_id])
      @current_palyer ||= Player.find_by(id: player_id)
    elsif (player_id = cookies.signed[:player_id])
      player = Player.find_by(id: player_id)
      if player && player.authenticated?(cookies[:remember_token])
        log_in player
        @current_player = player
      end
    end
  end
  
  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_player.nil?
  end
  
  # 永続的セッションを破棄する
  def forget(player)
    player.forget
    cookies.delete(:player_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_player)
    session.delete(:player_id)
    @current_player = nil
  end
end
