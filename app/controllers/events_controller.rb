class EventsController < ApplicationController
  before_action :find_organization

  def index
  end

  def new
    @event = Event.new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def find_organization
    @organization = Organization.where(id: params[:organization_id]).first
  end
end
