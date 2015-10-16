class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :busy

  belongs_to :organization
  has_and_belongs_to_many :events
  has_and_belongs_to_many :courses

  validates_presence_of :first_name, :last_name, :email, :organization_id
  validates_uniqueness_of :email
end
