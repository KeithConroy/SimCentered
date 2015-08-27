class WelcomeController < ApplicationController
  def index
    @organization = Organization.new
  end
end
