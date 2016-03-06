class Event < ActiveRecord::Base
  belongs_to :organization
  belongs_to :instructor, class_name: 'User'

  has_and_belongs_to_many :rooms
  has_and_belongs_to_many :students, class_name: 'User'
  has_and_belongs_to_many :items

  validates_presence_of :title, :organization_id
  validate :same_organization

  private

  def same_organization
    students.each do |student|
      if student.organization_id != organization_id
        students.delete(student)
        errors.add(:base, 'Invalid Student Association')
      end
    end
    rooms.each do |room|
      if room.organization_id != organization_id
        rooms.delete(room)
        errors.add(:base, 'Invalid Room Association')
      end
    end
    items.each do |item|
      if item.organization_id != organization_id
        items.delete(item)
        errors.add(:base, 'Invalid Item Association')
      end
    end
  end
end
