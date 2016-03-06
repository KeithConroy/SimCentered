class EventsController < ApplicationController
  before_action :find_event, only: [:show, :edit, :update, :destroy]

  before_action :nested_student, only: [:add_student, :remove_student]
  before_action :nested_room, only: [:add_room, :remove_room]
  before_action :nested_item, only: [:add_item, :remove_item]

  before_action :nested_event, only: [:modify, :add_course, :remove_course, :add_student, :remove_student, :add_room, :remove_room, :add_item, :remove_item, :modify_search]

  before_action :faculty, only: [:index, :new, :show, :edit]

  def index
    @new_event = Event.new
    if request.xhr?
      @calendar_events = Event.list_json(@organization.id, params[:start], params[:end])
      render json: @calendar_events
    else
      @events = Event.list(@organization.id, params[:page])
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.organization_id = @organization.id
    if @event.save
      redirect_to "/organizations/#{@organization.id}/events/#{@event.id}"
    else
      render json: @event.errors.full_messages, status: 400
    end
  end

  def show
  end

  def modify
  end

  def find_busy(conflicting_events)
    busy_students = []
    busy_rooms = []
    busy_items = []

    conflicting_events.each do |event|
      busy_students << event.students
      busy_rooms << event.rooms
      busy_items << event.items
    end

    mark_busy(@students, busy_students) unless busy_students.empty?
    mark_busy(@rooms, busy_rooms) unless busy_rooms.empty?
    mark_busy(@items, busy_items) unless busy_items.empty?
  end

  def mark_busy(full_array, busy_array)
    busy_array.flatten!.uniq!
    full_array.each do |object|
      object.busy = busy_array.include?(object)
    end
  end

  def edit
  end

  def update
    if @event.update_attributes(event_params)
      redirect_to organization_event_path(@organization.id, @event.id)
    else
      render json: @event.errors.full_messages, status: 400
    end
  end

  def destroy
    @event.destroy
    redirect_to(:action => 'index')
  end

  def add_course
    @course = Course.where(id: params[:id]).first
    if @course && @course.organization_id == @organization.id
      @course.students.each do |student|
        @event.students << student unless @event.students.include?(student)
      end
      if @event.save
        render :'events/_scheduled_students', layout: false
      else
        render json: @event.errors.full_messages, status: 400
      end
    else
      render json: @event.errors.full_messages, status: 400
    end
  end

  # def remove_course
  #   course = Course.where(id: params[:id])
  #   course.students.each do |student|
  #     @event.courses.delete(student)
  #   end
  #   @event.save
  #   render json: {user: @user, count: @event.courses.count, event: @event.id}
  # end

  def add_student
    if @student && @student.organization_id == @organization.id
      @event.students << @student unless @event.students.include?(@student)
      if @event.save
        # render :'events/_scheduled_students', layout: false
        render :'events/_scheduled_student', layout: false
      else
        render json: @event.errors.full_messages, status: 400
      end
    else
      render json: 'Invalid Student Association', status: 400
    end
  end

  def remove_student
    if @event.students.include?(@student)
      @event.students.delete(@student)
      if @event.save
        render json: { count: @event.students.count }
      else
        render json: @event.errors.full_messages, status: 400
      end
    else
      render json: 'Student is not enrolled', status: 400
    end
  end

  def add_room
    if @room && @room.organization_id == @organization.id
      @event.rooms << @room unless @event.students.include?(@student)
      if @event.save
        render :'events/_scheduled_rooms', layout: false
      else
        render json: @event.errors.full_messages, status: 400
      end
    else
      render json: 'Invalid Room Association', status: 400
    end
  end

  def remove_room
    @event.rooms.delete(@room)
    if @event.save
      render json: { count: @event.rooms.count }
    else
      render json: @event.errors.full_messages, status: 400
    end
  end

  def add_item
    @event.items << @item
    if @event.save
      render :'events/_scheduled_items', layout: false
    else
      render json: @event.errors.full_messages, status: 400
    end
  end

  def remove_item
    @event.items.delete(@item)
    if @event.save
      render json: { count: @event.items.count }
    else
      render json: @event.errors.full_messages, status: 400
    end
  end

  def search
    if params[:phrase] == '`'
      @events = Event.empty_search(@organization.id)
    else
      @events = Event.search(@organization.id, params[:phrase])
    end
    render :'events/_all_events', layout: false
  end

  def modify_search
    search_all
    conflicting_events = Event.conflicting(@organization.id, @event)
    find_busy(conflicting_events) unless conflicting_events.empty?

    render :'events/_modify_search', layout: false
  end

  def search_all
    search_available_students
    search_available_rooms
    search_available_items
  end

  def search_available_students
    @courses = Course.search(@organization.id, params[:phrase])
    @students = User.search_students(@organization.id, params[:phrase])
    @students -= @event.students
  end

  def search_available_rooms
    @rooms = Room.search(@organization.id, params[:phrase])
    @rooms -= @event.rooms
  end

  def search_available_items
    @items = Item.search(@organization.id, params[:phrase])
    @items -= @event.items
  end

  private

  def find_event
    @event = Event.where(id: params[:id]).first
  end

  def event_params
    params.require(:event).permit(:title, :start, :finish, :instructor_id)
  end

  def nested_event
    @event = Event.where(id: params[:event_id]).first
  end

  def nested_student
    @student = User.where(id: params[:id]).first
  end

  def nested_room
    @room = Room.where(id: params[:id]).first
  end

  def nested_item
    @item = Item.where(id: params[:id]).first
  end

  def faculty
    faculty = User.faculty(@organization.id)
    @faculty = faculty.map do |user|
      ["#{user.first_name} #{user.last_name}", user.id]
    end
  end
end
