module CourseAssociations
  extend ActiveSupport::Concern

  def add_student
    @course = find_course || return
    @student = User.where(id: params[:student_id]).first

    begin
      @course.students << @student
      render :'courses/_enrolled_student', layout: false, locals: { student: @student }
    rescue => e
      render json: { error: e}, status: 400
    end
  end

  def remove_student
    @course = find_course || return
    @student = User.where(id: params[:student_id]).first

    if @course.students.include?(@student)
      @course.students.delete(@student)
      render json: { count: @course.students.count } if @course.save
    else
      render json: 'Student is not enrolled', status: 400
    end
  end
end
