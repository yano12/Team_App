module TeamSessionsHelper
  
  # 渡されたチームでログインする
  def team_log_in(team)
    session[:team_id] = team.id
  end
  
  # 現在ログイン中のチームを返す (いる場合)
  def current_team
    if session[:team_id]
      @current_team ||= Team.find_by(id: session[:team_id])
    end
  end
end
