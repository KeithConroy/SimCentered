class CoursesController < ApplicationController
  before_action :find_organization
  before_action :find_course, only: [:show, :edit, :update, :destroy]

  before_action :realtion_variables, only: [:add_student, :remove_student]

  before_action :faculty, only: [:new, :edit]

  def index
    @courses = Course.where(organization_id: @organization.id).order(title: :asc)
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
    @students = User.where(organization_id: @organization.id, is_student: true).order(last_name: :asc).order(first_name: :asc)
    @students -= @course.students
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
    @course.students << @student
    @course.save
    render json: {student: @student, count: @course.students.count, course: @course.id}
  end

  def remove_student
    @course.students.delete(@student)
    @course.save
    render json: {student: @student, count: @course.students.count, course: @course.id}
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

  def faculty
    @users = User.where(organization_id: @organization.id, is_student: false).order(last_name: :asc).order(first_name: :asc)
    @faculty = @users.map do |user|
      ["#{user.first_name} #{user.last_name}", user.id]
    end
  end

  def realtion_variables
    @course = Course.where(id: params[:course_id]).first
    @student = User.where(id: params[:id]).first
  end

end