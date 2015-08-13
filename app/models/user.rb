class User < ActiveRecord::Base
  belongs_to :organization
  has_and_belongs_to_many :events

  validates_presence_of :first_name, :last_name, :email, :organization_id
  validates_uniqueness_of :email
end
