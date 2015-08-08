class CreateJoinTableEventItem < ActiveRecord::Migration
  def change
    create_join_table :events, :items do |t|
      # t.index [:event_id, :item_id]
      # t.index [:item_id, :event_id]
    end
  end
end
