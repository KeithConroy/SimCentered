class RoomsController < ApplicationController
  before_action :find_room, only: [:show, :edit, :update, :destroy]

  def index
    @new_room = Room.new
    @rooms = Room
      .where(organization_id: @organization.id)
      .order(title: :asc)
      .paginate(page: params[:page], per_page: 15)

    return render :'rooms/_all_rooms', layout: false if request.xhr?
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
    redirect_to(:action => 'index')
  end

  def search
    @rooms = Room
      .where("organization_id = ? AND lower(title) LIKE ?", @organization.id, "%#{params[:phrase]}%")
      .order(title: :asc)
      .paginate(page: 1, per_page: 15)
    return render :'rooms/_all_rooms', layout: false
  end

  private

  def find_room
    @room = Room.where(id: params[:id]).first
  end

  def room_params
    params.require(:room).permit(:title, :number, :building, :description)
  end
end
