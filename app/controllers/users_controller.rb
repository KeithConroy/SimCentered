class UsersController < ApplicationController
  skip_before_action :authorize_faculty, only: [:show, :edit, :update, :destroy]

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
    begin
      @user = find_user
      authorize_faculty_or_current_student(@user)
      @events = @user.events
        .where('start > ?', DateTime.now)
        .paginate(page: 1, per_page: 10)
    rescue => e
      render file: 'public/404.html', status: 404
    end
  end

  def edit
    begin
      @user = find_user
      authorize_faculty_or_current_student(@user)
    rescue => e
      render file: 'public/404.html', status: 404
    end
  end

  def update
    begin
      @user = find_user
      authorize_faculty_or_current_student(@user)
      if @user.update_attributes(user_params)
        redirect_to organization_user_path(@organization.id, @user.id)
      else
        render json: @user.errors.full_messages, status: 400
      end
    rescue => e
      render file: 'public/404.html', status: 404
    end
  end

  def destroy
    begin
      @user = find_user
      authorize_faculty_or_current_student(@user)
      @user.destroy
      redirect_to(action: 'index')
    rescue => e
      render file: 'public/404.html', status: 404
    end
  end

  def search
    @users = User.search(@organization.id, params[:phrase])
    render :'users/_all_users', layout: false
  end

  private

  def find_user
    authorize_resource(User.where(id: params[:id]).first)
  end

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :is_student, :password
    )
  end
end
