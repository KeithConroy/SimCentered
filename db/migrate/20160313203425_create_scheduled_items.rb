class CreateScheduledItems < ActiveRecord::Migration
  def change
    drop_table :events_items
  end
  def change
    create_table :scheduled_items do |t|
      t.belongs_to :event, index: true
      t.belongs_to :item, index: true
      t.integer :quantity, default: 0
      t.timestamps null: false
    end
  end
end
