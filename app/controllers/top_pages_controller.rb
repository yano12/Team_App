class TopPagesController < ApplicationController
  def home
    if logged_in?
      #@players = current_team.players.paginate(page: params[:page])
      @micropost = current_player.microposts.build
      @feed_items = current_player.feed.paginate(page: params[:page])
    end
  end
  
  def contact
  end
end
