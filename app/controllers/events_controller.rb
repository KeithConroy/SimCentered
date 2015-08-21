class EventsController < ApplicationController
  before_action :find_organization
  before_action :find_event, only: [:show, :edit, :update, :destroy]
  before_action :assign_student, only: [:add_student, :remove_student]
  before_action :assign_room, only: [:add_room, :remove_room]
  before_action :assign_item, only: [:add_item, :remove_item]

  def index
    @events = Event.where(organization_id: @organization.id).order(date: :asc).order(time: :asc)
  end

  def new
    @event = Event.new
    # @users = User.where(organization_id: @organization.id).order(last_name: :asc).order(first_name: :asc)
    # @rooms = Room.where(organization_id: @organization.id).order(title: :asc)
    # @items = Item.where(organization_id: @organization.id).order(title: :asc)
  end

  def create
    @event = Event.new(event_params)
    @event.organization_id = @organization.id
    if @event.save
      redirect_to organization_event_path(@organization.id, @event.id)
    else
      render json: "no"
    end
  end

  def show
    @users = User.where(organization_id: @organization.id).order(last_name: :asc).order(first_name: :asc)
    @users -= @event.students
    @rooms = Room.where(organization_id: @organization.id).order(title: :asc)
    @rooms -= @event.rooms
    @items = Item.where(organization_id: @organization.id).order(title: :asc)
    @items -= @event.items
  end

  def edit
  end

  def update
    if @event.update_attributes(event_params)
      redirect_to organization_event_path(@organization.id, @event.id)
    else

    end
  end

  def destroy
    @event.destroy
    redirect_to(:action => 'index')
  end

  def add_student
    @event.students << @user
    @event.save
    render json: {user: @user, count: @event.students.count, event: @event.id}
  end

  def remove_student
    @event.students.delete(@user)
    @event.save
    render json: {user: @user, count: @event.students.count, event: @event.id}
  end

  def add_room
    @event.rooms << @room
    @event.save
    render json: {room: @room, count: @event.rooms.count, event: @event.id}
  end

  def remove_room
    @event.rooms.delete(@room)
    @event.save
    render json: {room: @room, count: @event.rooms.count, event: @event.id}
  end

  def add_item
    @event.items << @item
    @event.save
    render json: {item: @item, count: @event.items.count, event: @event.id}
  end

  def remove_item
    @event.items.delete(@item)
    @event.save
    render json: {item: @item, count: @event.items.count, event: @event.id}
  end

  private

  def find_organization
    @organization = Organization.where(id: params[:organization_id]).first
  end

  def find_event
    @event = Event.where(id: params[:id]).first
  end

  def event_params
    params.require(:event).permit(:title, :date, :time, :organization_id)
  end

  def assign_student
    @event = Event.where(id: params[:event_id]).first
    @user = User.where(id: params[:id]).first
  end

  def assign_room
    @event = Event.where(id: params[:event_id]).first
    @room = Room.where(id: params[:id]).first
  end

  def assign_item
    @event = Event.where(id: params[:event_id]).first
    @item = Item.where(id: params[:id]).first
  end
end
