class Room < ActiveRecord::Base
  include BelongsToOrganization

  attr_accessor :busy

  has_and_belongs_to_many :events

  validates_presence_of :title

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
