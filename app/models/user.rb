class User < ActiveRecord::Base
  attr_accessor :busy

  belongs_to :organization
  has_and_belongs_to_many :events
  has_and_belongs_to_many :courses

  validates_presence_of :first_name, :last_name, :email, :organization_id
  validates_uniqueness_of :email

  def self.local(organization_id)
    where(organization_id: organization_id)
  end

  def self.list(organization_id, page)
    local(organization_id)
      .order(last_name: :asc, first_name: :asc)
      .paginate(page: page, per_page: 15)
  end

  def self.faculty(organization_id)
    local(organization_id)
      .where(is_student: false)
      .order(last_name: :asc, first_name: :asc)
  end

  def self.search_students(organization_id, phrase)
    local(organization_id)
      .where(is_student: true)
      .where(
        'lower(first_name) LIKE ? OR lower(last_name) LIKE ?',
        "%#{phrase}%", "%#{phrase}%"
      )
      .order(last_name: :asc, first_name: :asc)
  end

  def self.search(organization_id, phrase)
    local(organization_id)
      .where(
        'lower(first_name) LIKE ? OR lower(last_name) LIKE ?',
        "%#{phrase}%", "%#{phrase}%"
      )
      .order(last_name: :asc, first_name: :asc)
      .paginate(page: 1, per_page: 15)
  end

  def self.create_admin(organization_id, subdomain, email)
    create!(
      first_name: subdomain,
      last_name: 'Admin',
      email: email,
      password: '',
      is_student: false,
      organization_id: organization_id
    )
  end
end
