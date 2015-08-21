class Course < ActiveRecord::Base
  belongs_to :organization
  belongs_to :instructor, class_name: "User"

  has_and_belongs_to_many :students, class_name: "User"

  validates_presence_of :title
end
