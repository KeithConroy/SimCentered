class CoursesController < ApplicationController
  before_action :find_course, only: [:show, :edit, :update, :destroy]

  before_action :relation_variables, only: [:add_student, :remove_student]

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
    redirect_to(:action => 'index')
  end

  def add_student
    if @student && @student.organization_id == @organization.id
      @course.students << @student unless @course.students.include?(@student)
      if @course.save
        return render :'courses/_enrolled_students', layout: false
      else
        render json: @course.errors.full_messages, status: 400
      end
    else
      render json: "Invalid Student Association", status: 400
    end
  end

  def remove_student
    if @course.students.include?(@student)
      @course.students.delete(@student)
      if @course.save
        render json: {count: @course.students.count}
      end
    else
      render json: "Student is not enrolled", status: 400
    end
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
      .order(last_name: :asc, first_name: :asc)

    @students -= @course.students
  end

  private

  def find_course
    @course = Course.where(organization_id: @organization.id, id: params[:id]).first
    unless @course
      render file: "public/404.html"
    end
  end

  def course_params
    params.require(:course).permit(:title, :instructor_id)
  end

  def faculty
    @users = User
      .where(organization_id: @organization.id, is_student: false)
      .order(last_name: :asc, first_name: :asc)

    @faculty = @users.map do |user|
      ["#{user.first_name} #{user.last_name}", user.id]
    end
  end

  def relation_variables
    @course = Course.where(id: params[:course_id]).first
    @student = User.where(id: params[:id]).first
  end

end
