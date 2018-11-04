class EventsController < ApplicationController
  before_action :logged_in_player,  only: [:create, :destroy]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = Event.where(start: params[:start]..params[:end], team_id: current_team.id)
  end
  
  def show
  end
  
  def new
    if current_player.team_manager == true
      @event = Event.new
    end
  end

  def edit
  end

  def create
    @event = current_team.events.build(event_params)
    @event.team_id = current_team.id
    @event.save
  end

  def update
    @event.update(event_params)
  end

  def destroy
    @event.destroy
  end

  private
  
    # before
    
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:title, :date_range, :start, :end, :color)
    end
end