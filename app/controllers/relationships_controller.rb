class RelationshipsController < ApplicationController
  before_action :logged_in_player

  def create
    @team = Team.find(params[:followed_id])
    @players = @team.players
    current_team.follow(@team, @players)
    respond_to do |format|
      format.html { redirect_to @team }
      format.js
    end
  end

  def destroy
    @team = Relationship.find(params[:id]).followed
    @players = @team.players
    current_team.unfollow(@team, @players)
    respond_to do |format|
      format.html { redirect_to @team }
      format.js
    end
  end
end
