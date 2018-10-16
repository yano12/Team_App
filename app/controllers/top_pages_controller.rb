class TopPagesController < ApplicationController
  def home
    @players = current_team.players.paginate(page: params[:page]) if logged_in?
  end
  
  def contact
  end
end
