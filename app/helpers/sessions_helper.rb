module SessionsHelper
  
  # 渡されたユーザーでログインする
  def log_in(player)
    session[:player_id] = player.id
    session[:team_id] = player.team_id
  end
  
  # ユーザーのセッションを永続的にする
  def remember(player)
    player.remember
    cookies.permanent.signed[:player_id] = player.id
    cookies.permanent[:remember_token] = player.remember_token
  end
  
  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_player?(player)
    player == current_player
  end
  
  # 現在ログイン中のユーザーを返す (いる場合)
  def current_player
    if (player_id = session[:player_id])
      @current_player ||= Player.find_by(id: player_id)
    elsif (player_id = cookies.signed[:player_id])
      player = Player.find_by(id: player_id)
      if player && player.authenticated?(:remember, cookies[:remember_token])
        log_in player
        @current_player = player
      end
    end
  end
  
  # 渡されたチームがにユーザーが所属していればtrueを返す
  def current_team?(team)
    team == current_team
  end
  
  # 現在ログイン中のユーザーのチームを返す (いる場合)
  def current_team
    if session[:team_id]
      @current_team ||= Team.find.by(id: session[:team_id])
    end
  end
  
  # ユーザーがチーム管理者ならtrue、その他ならfalseを返す
  def team_manager?
    current_player.team_manager
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
  
  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
