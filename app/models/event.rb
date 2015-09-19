class Event < ActiveRecord::Base
  belongs_to :organization
  belongs_to :instructor, class_name: "User"

  has_and_belongs_to_many :rooms
  has_and_belongs_to_many :students, class_name: "User"
  has_and_belongs_to_many :items

  validates_presence_of :title, :organization_id
  validate :same_organization

  private

  def same_organization
    self.students.each do |student|
      if student.organization_id != self.organization_id
        self.students.delete(student)
        errors.add(:base, 'Invalid Student Association')
      end
    end
    self.rooms.each do |room|
      if room.organization_id != self.organization_id
        self.rooms.delete(room)
        errors.add(:base, 'Invalid Room Association')
      end
    end
    self.items.each do |item|
      if item.organization_id != self.organization_id
        self.items.delete(item)
        errors.add(:base, 'Invalid Item Association')
      end
    end
  end
end
