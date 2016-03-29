class RoomGroup < ActiveRecord::Base
  belongs_to :organization
  has_and_belongs_to_many :rooms

  validates_presence_of :title, :organization_id

  def self.local(organization_id)
    where(organization_id: organization_id)
  end
end
