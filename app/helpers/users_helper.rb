module UsersHelper
  def full_name(user)
    "#{user.first_name} #{user.last_name}"
  end

  def status(user)
    user.is_student ? "Student" : "Faculty"
  end
end
