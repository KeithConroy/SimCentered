class EventsController < ApplicationController
  skip_before_action :authorize_faculty, only: [:index]

  include UsersHelper
  include EventAssociations
  include EventSearch

  def index
    @new_event = Event.new
    @faculty = find_faculty_options
    if request.xhr?
      @calendar_events = Event.list_json(
        @organization.id, params[:start], params[:end]
      )
      render json: @calendar_events
    else
      @events = Event.list(@organization.id, params[:page])
    end
  end

  def new
    @event = Event.new
    @faculty = find_faculty_options
  end

  def create
    @event = Event.new(event_params)
    @event.organization_id = @organization.id
    if @event.save
      redirect_to organization_event_path(@organization.id, @event.id)
    else
      render json: @event.errors.full_messages, status: 400
    end
  end

  def show
    @event = find_event || return
    @faculty = find_faculty_options
  end

  def edit
    @event = find_event || return
    @faculty = find_faculty_options
  end

  def update
    @event = find_event || return
    if @event.update_attributes(event_params)
      redirect_to organization_event_path(@organization.id, @event.id)
    else
      render json: @event.errors.full_messages, status: 400
    end
  end

  def destroy
    @event = find_event || return
    @event.destroy
    redirect_to(action: 'index')
  end

  private

  def find_event
    authorize(Event.where(id: params[:id]).first)
  end

  def event_params
    params.require(:event).permit(:title, :start, :finish, :instructor_id)
  end
end
