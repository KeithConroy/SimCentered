module UsersHelper
  def full_name(user)
    "#{user.first_name} #{user.last_name}"
  end

  def status(user)
    if user.is_student
      "Student"
    else
      "Faculty"
    end
  end
end
