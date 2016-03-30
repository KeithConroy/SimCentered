class SessionsController < Devise::SessionsController
  skip_before_filter :authorize_faculty
end
