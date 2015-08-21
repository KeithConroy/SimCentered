class CoursesController < ApplicationController
  before_action :find_organization
  before_action :find_course, only: [:show, :edit, :update, :destroy]

  def index
    @courses = Course.where(organization_id: @organization.id).order(date: :asc).order(time: :asc)
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    @course.organization_id = @organization.id
    if @course.save
      redirect_to organization_course_path(@organization.id, @course.id)
    else
      render json: "no"
    end
  end

  def show
    # @users = User.where(organization_id: @organization.id).order(last_name: :asc).order(first_name: :asc)
    # @users -= @course.students
  end

  def edit
  end

  def update
    if @course.update_attributes(course_params)
      redirect_to organization_course_path(@organization.id, @course.id)
    else

    end
  end

  def destroy
    @course.destroy
    redirect_to(:action => 'index')
  end

  def add_student
    @course.students << @user
    @course.save
    render json: {user: @user, count: @course.students.count, course: @course.id}
  end

  def remove_student
    @course.students.delete(@user)
    @course.save
    render json: {user: @user, count: @course.students.count, course: @course.id}
  end

  private

  def find_organization
    @organization = Organization.where(id: params[:organization_id]).first
  end

  def find_course
    @course = Course.where(id: params[:id]).first
  end

  def course_params
    params.require(:course).permit(:title, :instructor_id, :organization_id)
  end

end
