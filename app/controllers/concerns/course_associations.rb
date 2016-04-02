module CourseAssociations
  extend ActiveSupport::Concern

  def add_student
    @course = find_course
    @student = find_student
    @course.students << @student
    render :'courses/_enrolled_student', layout: false, locals: { student: @student }
  end

  def remove_student
    @course = find_course
    @student = find_student

    @course.students.delete(@student)
    render json: { count: @course.students.count } if @course.save
  end

  private

  def find_student
    authorize_resource(User.where(id: params[:student_id]).first)
  end
end
