class MicropostsController < ApplicationController
  before_action :logged_in_player, only: [:create, :destroy]
  before_action :correct_micropost_player,   only: [:edit, :update, :destroy]
  
  def show
    @micropost = Micropost.find(params[:id])
    @comment = @micropost.comments.build
  end
  
  def edit
    @micropost = Micropost.find(params[:id])
  end 
  
  def update
    @micropost = Micropost.find(params[:id])
    if @micropost.update_attributes(micropost_params)
      flash[:success] = "投稿を更新しました"
      redirect_to root_url
    else
      render 'edit'
    end
  end

  def create
    @micropost = current_player.microposts.build(micropost_params)
    @micropost.team_id = current_player.team_id
    @micropost.team_name = current_team.name
    if @micropost.save
      flash[:success] = "投稿しました。"
      redirect_to root_url
    else
      @feed_items = []
      render 'top_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "投稿を削除しました。"
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end
    
    def correct_micropost_player
      @micropost = current_player.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end