class Event < ActiveRecord::Base
  belongs_to :organization
  belongs_to :instructor, class_name: 'User'

  has_and_belongs_to_many :rooms
  has_and_belongs_to_many :students, class_name: 'User'
  has_and_belongs_to_many :items

  validates_presence_of :title, :organization_id
  validate :same_organization

  def self.local(organization_id)
    where(organization_id: organization_id)
  end

  def self.list(organization_id, page)
    local(organization_id)
      .where('start > ?', DateTime.now)
      .order(start: :asc)
      .paginate(page: page, per_page: 15)
  end

  def self.list_json(organization_id, start, finish)
    events = local(organization_id).where(start: start..finish)
    events.map do |event|
      { title: event.title, start: event.start, :end => event.finish, url: "events/#{event.id}" }
    end
  end

  def self.conflicting(organization_id, event)
    local(organization_id)
      .where('(start BETWEEN ? AND ?) OR (finish BETWEEN ? AND ?)', event.start, event.finish, event.start, event.finish)
  end

  def self.search(organization_id, phrase)
    local(organization_id)
      .where('lower(title) LIKE ?', "%#{phrase}%")
      .order(start: :asc)
      .paginate(page: 1, per_page: 15)
  end

  def self.empty_search(organization_id)
    local(organization_id)
      .order(start: :asc)
      .paginate(page: 1, per_page: 15)
  end

  def self.today(organization_id)
    local(organization_id)
      .where('start BETWEEN ? AND ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day)
      .order(start: :asc)
  end

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
