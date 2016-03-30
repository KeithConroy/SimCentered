class Event < ActiveRecord::Base
  belongs_to :organization
  belongs_to :instructor, class_name: 'User'

  has_and_belongs_to_many :courses,
    before_add: [:check_organization, :add_students],
    before_remove: :remove_students
  has_and_belongs_to_many :students, class_name: 'User',
    before_add: :check_organization
  has_and_belongs_to_many :rooms,
    before_add: :check_organization
  has_many :scheduled_items
  has_many :items, through: :scheduled_items,
    before_add: :check_organization

  validates_presence_of :title, :organization_id

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
      {
        title: event.title,
        start: event.start,
        :end => event.finish,
        url: "events/#{event.id}"
      }
    end
  end

  def self.conflicting(organization_id, event)
    local(organization_id)
      .where(
        '(start BETWEEN ? AND ?) OR (finish BETWEEN ? AND ?)',
        event.start, event.finish, event.start, event.finish
      )
  end

  def self.search(organization_id, phrase)
    local(organization_id)
      .where('lower(title) LIKE ?', "%#{phrase}%")
      .order(start: :asc)
      .paginate(page: 1, per_page: 15)
  end

  def self.today(organization_id)
    local(organization_id)
      .where(
        'start BETWEEN ? AND ?',
        DateTime.now.beginning_of_day, DateTime.now.end_of_day
      )
      .order(start: :asc)
  end

  private

  def check_organization(resource)
    if resource.organization_id != organization_id
      raise "This #{resource.class} does not belong to your organization"
    end
  end

  def add_students(course)
    course.students.each do |student|
      students << student
    end
  end

  def remove_students(course)
    course.students.each do |student|
      students.delete(student)
    end
  end
end
