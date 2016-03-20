class ScheduledItem < ActiveRecord::Base
  belongs_to :event
  belongs_to :item
end
