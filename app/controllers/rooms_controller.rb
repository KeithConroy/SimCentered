class RoomsController < ApplicationController
  before_action :find_room, only: [:show, :edit, :update, :destroy]

  def index
    @rooms = Room.where(organization_id: @organization.id).order(title: :asc)
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    @room.organization_id = @organization.id
    if @room.save
      redirect_to @room
    else
      render json: "no"
    end
  end

  def show
  end

  def edit
  end

  def update
    if @room.update_attributes(room_params)
      redirect_to @room
    else

    end
  end

  def destroy
    @room.destroy
    redirect_to(:action => 'index')
  end

  private

  def find_room
    @room = Room.where(id: params[:id]).first
  end

  def room_params
    params.require(:room).permit(:title, :number, :building, :description)
  end
end
