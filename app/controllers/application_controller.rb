class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :get_organization

  private
    def get_organization

      organizations = Organization.where(subdomain: request.subdomain)

      if organizations.count > 0
        @organization = organizations.first
      elsif request.subdomain != 'www'
        redirect_to root_url(subdomain: 'www')
      end
    end
end
