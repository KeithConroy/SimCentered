class CoursesController < ApplicationController
  include UsersHelper
  include CourseAssociations
  include CourseSearch

  def index
    @new_course = Course.new
    @courses = Course.list(@organization.id, params[:page])
    @faculty = find_faculty_options

    render :'courses/_all_courses', layout: false if request.xhr?
  end

  def new
    @faculty = find_faculty_options
  end

  def create
    @course = Course.new(course_params)
    @course.organization_id = @organization.id
    if @course.save
      redirect_to organization_course_path(@organization.id, @course.id)
    else
      render json: @course.errors.full_messages, status: 400
    end
  end

  def show
    @course = find_course || return
    @events = @course.events
      .where('start > ?', DateTime.now)
      .paginate(page: 1, per_page: 10)
    @students = @course.students
      .paginate(page: params[:page], per_page: 10)
    @faculty = find_faculty_options
  end

  def edit
    @course = find_course || return
    @faculty = find_faculty_options
  end

  def update
    @course = find_course || return
    if @course.update_attributes(course_params)
      redirect_to organization_course_path(@organization.id, @course.id)
    else
      render json: @course.errors.full_messages, status: 400
    end
  end

  def destroy
    @course = find_course || return
    @course.destroy
    redirect_to(action: 'index')
  end

  private

  def find_course
    authorize(Course.where(id: params[:id]).first)
  end

  def course_params
    params.require(:course).permit(:title, :instructor_id)
  end
end
