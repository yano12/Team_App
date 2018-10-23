class FeedsController < ApplicationController
  
  def index
    @microposts = Micropost.order(created_at: :desc).page(params[:page])
    respond_to do |format|
      format.rss { render layout: false }
    end
  end
end
