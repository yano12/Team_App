class RelationshipsController < ApplicationController
  before_action :logged_in_player

  def create
    @team = Team.find(params[:followed_id])
    current_team.follow(@team)
    respond_to do |format|
      format.html { redirect_to @team }
      format.js
    end
  end

  def destroy
    @team = Relationship.find(params[:id]).followed
    current_team.unfollow(@team)
    respond_to do |format|
      format.html { redirect_to @team }
      format.js
    end
  end
end
