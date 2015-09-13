class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :find_organization, :set_time_zone

  def find_organization
    @organization = Organization.where(id: params[:id]).first
  end

  def set_time_zone
    Time.zone = @organization.time_zone if @organization
  end
end
