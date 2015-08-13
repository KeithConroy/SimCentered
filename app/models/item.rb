class Item < ActiveRecord::Base
  belongs_to :organization

  validates_presence_of :title, :quantity, :organization_id
  validates_uniqueness_of :title
end
