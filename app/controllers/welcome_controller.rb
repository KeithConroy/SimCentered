class WelcomeController < ApplicationController
  def index
    @organization = Organization.new
  end

  def community
    @organization = Organization.where(id: params[:id]).first
    @organizations = Organization.all
  end
end
