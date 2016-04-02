module CourseAssociations
  extend ActiveSupport::Concern

  def add_student
    @course = find_course || return
    @student = User.where(id: params[:student_id]).first

    if @student && @student.organization_id == @organization.id
      @course.students << @student unless @course.students.include?(@student)
      if @course.save
        render :'courses/_enrolled_student', layout: false, locals: { student: @student }
      else
        render json: @course.errors.full_messages, status: 400
      end
    else
      render json: 'Invalid Student Association', status: 400
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
