class OrganizationsController < ApplicationController

  def index

  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      @admin = User.create!(
        first_name: organization_params[:title],
        last_name: "Admin",
        email: organization_params[:email],
        password: "",
        organization_id: @organization.id
      )
      redirect_to organization_path(@organization.id)
    else
      render json: "no"
    end
  end

  def show
    @organization = Organization.where(id: params[:id]).first
    @event = Event.new()
    @events = Event.where(organization_id: @organization.id).where('start BETWEEN ? AND ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day).order(start: :asc)
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def organization_params
    params.require(:organization).permit(:title, :email)
  end
end
