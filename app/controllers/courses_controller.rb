class CoursesController < ApplicationController
  before_action :find_course, except: [:index, :new, :create, :search]
  before_action :faculty, only: [:index, :new, :show, :edit]

  include CourseAssociations
  include CourseSearch

  def index
    @new_course = Course.new
    @courses = Course.list(@organization.id, params[:page])

    render :'courses/_all_courses', layout: false if request.xhr?
  end

  def new
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
    @events = @course.events
      .where('start > ?', DateTime.now)
      .paginate(page: 1, per_page: 10)
    @students = @course.students
      .paginate(page: params[:page], per_page: 10)
  end

  def edit
  end

  def update
    if @course.update_attributes(course_params)
      redirect_to organization_course_path(@organization.id, @course.id)
    else
      render json: @course.errors.full_messages, status: 400
    end
  end

  def destroy
    @course.destroy
    redirect_to(action: 'index')
  end

  private

  def find_course
    @course = Course.where(organization_id: @organization.id, id: params[:id]).first
    unless @course
      render file: "public/404.html", status: 404
    end
  end

  def course_params
    params.require(:course).permit(:title, :instructor_id)
  end

  def faculty
    faculty = User.faculty(@organization.id)
    @faculty = faculty.map do |user|
      ["#{user.first_name} #{user.last_name}", user.id]
    end
  end

end
