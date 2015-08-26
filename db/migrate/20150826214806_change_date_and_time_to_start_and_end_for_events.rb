class ChangeDateAndTimeToStartAndEndForEvents < ActiveRecord::Migration
  def change
    remove_column :events, :date
    remove_column :events, :time
    add_column :events, :start, :datetime
    add_column :events, :end, :datetime
  end
end
