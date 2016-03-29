class RoomsController < ApplicationController
  before_action :find_room, only: [:show, :edit, :update, :destroy, :heatmap]

  include EventsHelper

  def index
    @new_room = Room.new
    @rooms = Room.list(@organization.id, params[:page])
      .where(organization_id: @organization.id)
      .order(title: :asc)
      .paginate(page: params[:page], per_page: 15)
    @groups = RoomGroup.local(@organization.id)
    @new_group = RoomGroup.new

    render :'rooms/_all_rooms', layout: false if request.xhr?
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    @room.organization_id = @organization.id
    if @room.save
      redirect_to organization_room_path(@organization.id, @room.id)
    else
      render json: @room.errors.full_messages, status: 400
    end
  end

  def show
    @events = @room.events
      .where('start > ?', DateTime.now)
      .paginate(page: 1, per_page: 10)
  end

  def edit
  end

  def update
    if @room.update_attributes(room_params)
      redirect_to organization_room_path(@organization.id, @room.id)
    else
      render json: @room.errors.full_messages, status: 400
    end
  end

  def destroy
    @room.destroy
    redirect_to(action: 'index')
  end

  def search
    @rooms = Room
      .search(@organization.id, params[:phrase])
      .paginate(page: 1, per_page: 15)
    render :'rooms/_all_rooms', layout: false
  end

  def heatmap
    data = heatmap_data(@room)
    unless data.empty?
      quarter = data.values.max / 4
      legend = [quarter,quarter*2,quarter*3,quarter*4]
    end

    render json: { data: data, name: ['hour', 'hours'], legend: legend || [2,4,6,8]}
  end

  private

  def find_room
    @room = Room.where(organization_id: @organization.id, id: params[:id]).first
    unless @room
      render file: "public/404.html", status: 404
    end
  end

  def room_params
    params.require(:room).permit(:title, :number, :building, :description)
  end

  def heatmap_data(room, data = {})
    room.events.each do |event|
      if event.start < DateTime.now
        timestamp = event.start.to_i.to_s
        data[timestamp] = event_duration(event)
      end
    end
    data
  end
end
