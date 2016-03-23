class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy]

  def index
    @new_user = User.new
    @users = User.list(@organization.id, params[:page])

    render :'users/_all_users', layout: false if request.xhr?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.organization_id = @organization.id
    if @user.save
      redirect_to organization_user_path(@organization.id, @user.id)
    else
      render json: @user.errors.full_messages, status: 400
    end
  end

  def show
    @events = @user.events
      .where('start > ?', DateTime.now)
      .paginate(page: 1, per_page: 10)
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to organization_user_path(@organization.id, @user.id)
    else
      render json: @user.errors.full_messages, status: 400
    end
  end

  def destroy
    @user.destroy
    redirect_to(action: 'index')
  end

  def search
    @users = User.search(@organization.id, params[:phrase])
    render :'users/_all_users', layout: false
  end

  private

  def find_user
    @user = User.where(organization_id: @organization.id, id: params[:id]).first
    unless @user
      render file: "public/404.html"
    end
  end

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :is_student, :password
    )
  end
end
