class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :rooms, :events do |t|
      # t.index [:room_id, :event_id]
      # t.index [:event_id, :room_id]
    end
  end
end
