class Item < ActiveRecord::Base
  include BelongsToOrganization

  attr_accessor :busy

  has_many :scheduled_items
  has_many :events, through: :scheduled_items

  validates_presence_of :title, :quantity

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
