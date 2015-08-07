class OrganizationsController < ApplicationController

  def index

  end

  def new
  end

  def create
  end

  def show
    @organization = Organization.where(id: params[:id]).first
    @event = Event.new()
    @events = Event.where(organization_id: @organization.id, date: Date.today).order(time: :asc)
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
