module CourseSearch
  extend ActiveSupport::Concern

  def search
    @courses = Course.search(@organization.id, params[:phrase])
    render :'courses/_all_courses', layout: false
  end

  def modify_search
    @course = find_course || return
    search_available_students
    render :'courses/_modify_search', layout: false
  end

  private

  def search_available_students
    @students = User.search_students(@organization.id, params[:phrase])
    @students -= @course.students
  end
end
