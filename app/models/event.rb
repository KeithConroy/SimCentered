class Event < ActiveRecord::Base
  belongs_to :organization
  has_many :rooms
  has_many :users
end
