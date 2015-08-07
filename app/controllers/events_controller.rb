class EventsController < ApplicationController
  before_action :find_organization
  before_action :find_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = Event.where(organization_id: @organization.id).order(date: :asc)
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
      render json: "no"
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

    end
  end

  def destroy
    @event.destroy
    redirect_to(:action => 'index')
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
end
