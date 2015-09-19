class Item < ActiveRecord::Base

  attr_accessor :busy

  belongs_to :organization

  validates_presence_of :title, :quantity, :organization_id
end
