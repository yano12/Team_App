class PlayersController < ApplicationController
  
  def show
    @player = Player.find(params[:id])
  end
  
  def new
    @player = Player.new
  end
  
  def create
    @player = current_team.players.build(player_params)
    if @player.save
      flash[:success] = "ユーザーアカウントを作成しました"
      redirect_to @player
    else
      render 'new'
    end
  end

  private

    def player_params
      params.require(:player).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
