class EventsController < ApplicationController
  before_action :logged_in_player,  only: [:create, :destroy]
  #before_action :manager_player,    only: [:create, :edit, :update, :destroy]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  #before_action :correct_event_team, only: [:edit, :update, :destroy]

  def index
    @events = Event.where(start: params[:start]..params[:end])
  end
  
  def show
  end
  
  def new
    @event = Event.new
  end

  def edit
  end

  def create
    @event = Event.new(event_params)
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
    
    # 自チームのイベントかどうか確認
    def correct_event_team
      @event = Event.find_by(team_id: params[:team_id])
      redirect_to(root_url) unless @event.team_id == current_team.id
    end

    def event_params
      params.require(:event).permit(:title, :date_range, :start, :end, :color, :team_id)
    end
end