class Room < ActiveRecord::Base

  attr_accessor :busy

  belongs_to :organization
  has_and_belongs_to_many :events

  validates_presence_of :title, :organization_id
end
