class WelcomeController < ApplicationController
  def index
    # @organization = Organization.new
  end

  def community
    @organizations = Organization.all
  end
end
