class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!, :authorize_faculty
  before_action :find_organization, :set_time_zone, :set_locale

  include Errors::RescueError
  include Authorization

  private

  def find_organization
    @organization = Organization.where(id: current_user.organization_id).first if current_user
    if params[:organization_id] && @organization
      if params[:organization_id].to_i != @organization.id
        raise Errors::Forbidden
      end
    end
  end

  def set_time_zone
    Time.zone = @organization.time_zone if @organization
  end

  def set_locale
    I18n.locale = params[:locale].to_sym if params[:locale]
  end
end
