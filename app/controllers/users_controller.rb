class UsersController < ApplicationController
  before_action :find_organization
  before_action :find_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.where(organization_id: @organization.id).order(last_name: :asc).order(first_name: :asc)
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
      render json: "no"
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to organization_user_path(@organization.id, @user.id)
    else

    end
  end

  def destroy
    @user.destroy
    redirect_to(:action => 'index')
  end

  private

  def find_organization
    @organization = Organization.where(id: params[:organization_id]).first
  end

  def find_user
    @user = User.where(id: params[:id]).first
  end

  def user_params
    params.require(:user).permit(:title, :number, :building, :description)
  end
end
