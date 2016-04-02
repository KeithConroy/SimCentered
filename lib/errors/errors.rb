module Errors
  class NotFound < StandardError; end
  class Forbidden < StandardError; end
  class DuplicateAssignment < StandardError; end

  module RescueError

    def self.included(base)
      base.rescue_from Errors::NotFound do |e|
        render file: "public/404.html", :status => 404
      end
      base.rescue_from Errors::Forbidden do |e|
        render file: "public/403.html", :status => 403
      end
      base.rescue_from Errors::DuplicateAssignment do |e|
        render json: { error: e }, status: 400
      end
    end

  end
end
