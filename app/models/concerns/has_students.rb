module HasStudents
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :students, class_name: 'User',
      before_add: [:check_organization, :check_duplicate_student]
  end

  private

  def check_duplicate_student(user)
    if students.include?(user)
      raise "Student is already added to this #{self.class}"
    end
  end
end
