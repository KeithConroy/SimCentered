class Event < ActiveRecord::Base
  belongs_to :organization
  has_and_belongs_to_many :rooms
  has_and_belongs_to_many :users
  has_and_belongs_to_many :items
end
