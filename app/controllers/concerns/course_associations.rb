module CourseAssociations
  extend ActiveSupport::Concern

  def add_student
    begin
      @course = find_course
      @student = User.where(id: params[:student_id]).first
      @course.students << @student
      render :'courses/_enrolled_student', layout: false, locals: { student: @student }
    rescue => e
      render json: { error: e }, status: 400
    end
  end

  def remove_student
    begin
      @course = find_course
      @student = User.where(id: params[:student_id]).first

      @course.students.delete(@student)
      render json: { count: @course.students.count } if @course.save
    rescue => e
      render json: { error: e }, status: 400
    end
  end
end
