class Camera < ActiveRecord::Base
  belongs_to :organization
  belongs_to :room

  def self.local(organization_id)
    where(organization_id: organization_id)
  end

  def self.list(organization_id, page)
    local(organization_id)
      .order(id: :asc)
      .paginate(page: page, per_page: 15)
  end

  def self.search(organization_id, phrase)
    local(organization_id)
      .where('lower(name) LIKE ?', "%#{phrase}%")
      .order(name: :asc)
  end
end
