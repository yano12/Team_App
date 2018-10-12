module SessionsHelper
  
  # 渡されたユーザーでログインする
  def log_in(player)
    session[:player_id] = player.id
    session[:team_id] = player.team_id
  end
  
  # 現在ログイン中のユーザーを返す (いる場合)
  def current_player
    if session[:player_id]
      @current_player ||= Player.find_by(id: session[:player_id])
    end
  end
  
  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_player.nil?
  end
  
  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:player_id)
    @current_player = nil
  end
end
