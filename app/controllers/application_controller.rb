class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :find_organization, :set_time_zone

  def find_organization
    # p "*()"*80
    # if params[:organization_id]
    #   @organization = Organization.where(id: params[:organization_id]).first
    # elsif params[:id]
      # @organization = Organization.where(id: params[:id]).first
    # elsif current_user
      @organization = Organization.where(id: current_user.organization_id).first if current_user
    # else
    #   @organization = Organization.where(id: 1).first
    # end
  end

  def set_time_zone
    Time.zone = @organization.time_zone if @organization
  end
end
