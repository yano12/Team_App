class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = Event.where(start: params[:start]..params[:end])
  end
  
  def show
    #@event = Event.all
    # 返却するレスポンスのフォーマットを切り替える
    #respond_to do |format|
      # オブジェクトをJSON形式に変換した上で返す
      #format.json { render json: @event.to_json( only: [:id, :title, :start, :end] ) }
    #end
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
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:title, :date_range, :start, :end, :color)
    end
end