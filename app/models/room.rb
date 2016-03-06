class Room < ActiveRecord::Base
  attr_accessor :busy

  belongs_to :organization
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
  end
end
