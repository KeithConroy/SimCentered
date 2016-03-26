class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    # @organization = Organization.new
  end

  def community
  end
end
