class Organization < ActiveRecord::Base
  attr_accessor :email
  validates_presence_of :title
  validates_uniqueness_of :title
end
