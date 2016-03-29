class RoomGroupsController < ApplicationController
  def index
  end

  def new
  end

  def create
    @group = RoomGroup.new(group_params)
    params[:room_group][:room_ids].each do |room_id|
      room = Room.where(id: room_id).first
      @group.rooms << room if room
    end
    @group.organization_id = @organization.id
    if @group.save
      redirect_to organization_room_group_path(@organization.id, @group.id)
    else
      render json: @group.errors.full_messages, status: 400
    end
  end

  def show
    @group = RoomGroup.where(id: params[:id]).first
    @rooms = Room.local(@organization.id)
  end

  def edit
  end

  def update
    @group = RoomGroup.where(id: params[:id]).first
    if @group.update_attributes(group_params)
      params[:room_group][:room_ids].each do |room_id|
        room = Room.where(id: room_id).first
        @group.rooms << room if room && !@group.rooms.include?(room)
      end
      redirect_to organization_room_group_path(@organization.id, @group.id)
    else
      render json: @group.errors.full_messages, status: 400
    end
  end

  def destroy
    @group = RoomGroup.where(id: params[:id]).first
    @group.destroy
    redirect_to organization_rooms_path(@organization.id)
  end

  private

  def group_params
    params.require(:room_group).permit(:title)
  end
end
