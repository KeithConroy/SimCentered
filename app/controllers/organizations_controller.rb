class OrganizationsController < ApplicationController

  def index
  end

  def new
  end

  def create
  end

  def show
    @event = Event.new()
    @organization = Organization.where(id: params[:id]).first
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
