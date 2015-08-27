class Organization < ActiveRecord::Base

  attr_accessor :email

  validates_presence_of :title, :subdomain
  validates_uniqueness_of :title, :subdomain

end
