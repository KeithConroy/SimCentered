class UsersController < ApplicationController
  # before_action :find_organization
  before_action :find_user, only: [:show, :edit, :update, :destroy]

  def index
    @new_user = User.new
    # @users = User.where(organization_id: @organization.id).order(last_name: :asc).order(first_name: :asc)
    get_paged_users
    return render :'users/_all_users', layout: false if request.xhr?
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

  def search
    @users = User
      .where("organization_id = ? AND lower(first_name) LIKE ? OR lower(last_name) LIKE ?", @organization.id, "%#{params[:phrase]}%", "%#{params[:phrase]}%")
      .order(last_name: :asc)
      .order(first_name: :asc)
      .paginate(page: 1, per_page: 15)
    return render :'users/_all_users', layout: false
  end

  private

  def find_organization
    @organization = Organization.where(id: params[:organization_id]).first
  end

  def find_user
    @user = User.where(id: params[:id]).first
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :is_student, :password)
  end

  def get_paged_users
    @users = User
      .where(organization_id: @organization.id)
      .order(last_name: :asc)
      .order(first_name: :asc)
      .paginate(page: params[:page], per_page: 15)
  end
end
