class CoursesController < ApplicationController
  before_action :find_course, only: [
    :show, :edit, :update, :destroy, :modify_search,
    :add_student, :remove_student
  ]
  before_action :find_student, only: [:add_student, :remove_student]
  before_action :faculty, only: [:index, :new, :show, :edit]

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

  def add_student
    if @student && @student.organization_id == @organization.id
      @course.students << @student unless @course.students.include?(@student)
      if @course.save
        # render :'courses/_enrolled_students', layout: false
        render :'courses/_enrolled_student', layout: false, locals: { student: @student }
      else
        render json: @course.errors.full_messages, status: 400
      end
    else
      render json: 'Invalid Student Association', status: 400
    end
  end

  def remove_student
    if @course.students.include?(@student)
      @course.students.delete(@student)
      render json: { count: @course.students.count } if @course.save
    else
      render json: 'Student is not enrolled', status: 400
    end
  end

  def search
    @courses = Course.search(@organization.id, params[:phrase])
    render :'courses/_all_courses', layout: false
  end

  def modify_search
    search_available_students
    render :'courses/_modify_search', layout: false
  end

  private

  def find_course
    @course = Course.where(id: params[:id]).first
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

  def find_student
    @student = User.where(id: params[:student_id]).first
  end

  def search_available_students
    @students = User.search_students(@organization.id, params[:phrase])
    @students -= @course.students
  end
end
