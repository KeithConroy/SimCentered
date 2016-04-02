module Authorization
  extend ActiveSupport::Concern

  private

  def authorize_faculty
    if current_user.is_student
      raise Errors::Forbidden
    end
  end

  def authorize_resource(resource)
    if resource && current_user.organization_id == resource.organization_id
      return resource
    else
      raise Errors::NotFound
    end
  end

  def authorize_faculty_or_current_student(user)
    if current_user.is_student && current_user != user
      raise Errors::Forbidden
    end
  end

  def after_sign_in_path_for(user)
    if current_user.is_student
      organization_user_path(current_user.organization_id, current_user.id)
    else
      super
    end
  end
end
