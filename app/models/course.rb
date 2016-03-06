class Course < ActiveRecord::Base
  belongs_to :organization
  belongs_to :instructor, class_name: 'User'

  has_and_belongs_to_many :students, class_name: 'User'

  validates_presence_of :title, :organization_id
  validate :same_organization

  private

  def same_organization
    students.each do |student|
      if student.organization_id != organization_id
        students.delete(student)
        errors.add(:base, 'Invalid Association')
      end
    end
  end
end
