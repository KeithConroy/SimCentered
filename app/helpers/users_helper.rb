module UsersHelper
  def full_name(user)
    "#{user.first_name} #{user.last_name}"
  end

  def status(user)
    user.is_student ? 'Student' : 'Faculty'
  end

  def find_faculty_options
    faculty = User.faculty(@organization.id)
    faculty.map do |user|
      ["#{user.first_name} #{user.last_name}", user.id]
    end
  end
end
