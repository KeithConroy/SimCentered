class EventsController < ApplicationController
  before_action :find_event, except: [:index, :new, :create, :search]
  before_action :faculty, only: [:index, :new, :show, :edit]

  include UsersHelper
  include EventAssociations
  include EventSearch

  def index
    @new_event = Event.new
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
    redirect_to(action: 'index')
  end

  private

  def find_event
    @event = Event.where(organization_id: @organization.id, id: params[:id]).first
    unless @event
      render file: "public/404.html", status: 404
    end
  end

  def event_params
    params.require(:event).permit(:title, :start, :finish, :instructor_id)
  end

  def faculty
    faculty = User.faculty(@organization.id)
    @faculty = faculty.map do |user|
      ["#{user.first_name} #{user.last_name}", user.id]
    end
  end
end
