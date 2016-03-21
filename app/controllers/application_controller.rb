class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :find_organization, :set_time_zone

  def find_organization
    if request.subdomain != 'www'
      redirect_to root_url(subdomain: 'www')
    end
    @organization = Organization.where(subdomain: request.subdomain).first

    @organization = Organization.where(id: current_user.organization_id).first if current_user
    if params[:organization_id] && params[:organization_id].to_i != @organization.id
      render file: "public/401.html", status: :unauthorized
    end
  end

  def set_time_zone
    Time.zone = @organization.time_zone if @organization
  end
end
