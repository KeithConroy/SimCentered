class Course < ActiveRecord::Base
  belongs_to :organization
  belongs_to :instructor, class_name: 'User'

  has_and_belongs_to_many :students, class_name: 'User', before_add: [:check_organization, :check_duplicate]
  has_and_belongs_to_many :events

  validates_presence_of :title, :organization_id

  def self.local(organization_id)
    where(organization_id: organization_id)
  end

  def self.list(organization_id, page)
    local(organization_id)
      .order(title: :asc)
      .paginate(page: page, per_page: 15)
  end

  def self.search(organization_id, phrase)
    local(organization_id)
      .where('lower(title) LIKE ?', "%#{phrase}%")
      .order(title: :asc)
      .paginate(page: 1, per_page: 15)
  end

  private

  def check_organization(resource)
    if resource.organization_id != organization_id
      raise "This #{resource.class} does not belong to your organization"
    end
  end

  def check_duplicate(user)
    if students.include?(user)
      raise "Student is already added to this course"
    end
  end
end
