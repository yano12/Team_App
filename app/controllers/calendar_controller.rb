class CalendarController < ApplicationController
  
  def index
    @team = Team.find(params[:id])
  end
end
