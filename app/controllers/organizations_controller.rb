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
        first_name: organization_params[:subdomain],
        last_name: "Admin",
        email: organization_params[:email],
        password: "",
        is_student: false,
        organization_id: @organization.id
      )
      redirect_to organization_path(@organization.id)
    else
      render json: "no"
    end
  end

  def show
    @event = Event.new()
    @events = Event.where(organization_id: @organization.id).where('start BETWEEN ? AND ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day).order(start: :asc)
  end

  def edit
  end

  def update
    if @organization.update_attributes(organization_params)
      redirect_to @organization
    else

    end
  end

  def destroy
  end

  private

  def organization_params
    params.require(:organization).permit(:title, :subdomain, :email)
  end
end
