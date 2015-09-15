class CoursesController < ApplicationController
  # before_action :find_organization
  before_action :find_course, only: [:show, :edit, :update, :destroy]

  before_action :realtion_variables, only: [:add_student, :remove_student]

  before_action :faculty, only: [:index, :new, :show, :edit]

  def index
    @new_course = Course.new
    @courses = Course
      .where(organization_id: @organization.id)
      .order(title: :asc)
      .paginate(page: params[:page], per_page: 15)

    return render :'courses/_all_courses', layout: false if request.xhr?
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
    # @students = User
    #   .where(organization_id: @organization.id, is_student: true)
    #   .order(last_name: :asc)
    #   .order(first_name: :asc)
    # @students -= @course.students
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
    @course.students << @student unless @course.students.include?(@student)
    @course.save
    return render :'courses/_enrolled_students', layout: false
    # render json: {student: @student, count: @course.students.count, course: @course.id}
  end

  def remove_student
    @course.students.delete(@student)
    @course.save
    render json: {count: @course.students.count}
  end

  def search
    @courses = Course
      .where("organization_id = ? AND lower(title) LIKE ?", @organization.id, "%#{params[:phrase]}%")
      .order(title: :asc)
      .paginate(page: 1, per_page: 15)
    return render :'courses/_all_courses', layout: false
  end

  def modify_search
    @course = Course.where(id: params[:course_id]).first
    @phrase = params[:phrase]
    search_available_students

    return render :'courses/_modify_search', layout: false
  end

  def search_available_students
    @students = User
      .where(organization_id: @organization.id, is_student: true)
      .where("lower(first_name) LIKE ? OR lower(last_name) LIKE ?", "%#{params[:phrase]}%", "%#{params[:phrase]}%")
      .order(last_name: :asc)
      .order(first_name: :asc)
    @students -= @course.students
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
    @users = User
      .where(organization_id: @organization.id, is_student: false)
      .order(last_name: :asc)
      .order(first_name: :asc)
    @faculty = @users.map do |user|
      ["#{user.first_name} #{user.last_name}", user.id]
    end
  end

  def realtion_variables
    @course = Course.where(id: params[:course_id]).first
    @student = User.where(id: params[:id]).first
  end

end
