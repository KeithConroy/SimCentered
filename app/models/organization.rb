class Organization < ActiveRecord::Base
  attr_accessor :email

  validates_presence_of :title, :subdomain
  validates_uniqueness_of :title, :subdomain

  before_destroy :delete_courses, :delete_events,
    :delete_rooms, :delete_items, :delete_users

  private

  def delete_courses
    Course.delete_all(organization_id: id)
  end

  def delete_events
    Event.delete_all(organization_id: id)
  end

  def delete_rooms
    Room.delete_all(organization_id: id)
  end

  def delete_items
    Item.delete_all(organization_id: id)
  end

  def delete_users
    User.delete_all(organization_id: id)
  end
end
