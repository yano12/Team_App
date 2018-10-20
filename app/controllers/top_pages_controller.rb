class TopPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_player.microposts.build
      @feed_items = current_team.feed.paginate(page: params[:page])
    end
  end
  
  def contact
  end
end
