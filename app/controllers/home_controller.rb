class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :authorize_faculty

  def index
  end
end
