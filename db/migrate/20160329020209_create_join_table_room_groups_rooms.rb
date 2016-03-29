class CreateJoinTableRoomGroupsRooms < ActiveRecord::Migration
  def change
    create_join_table :room_groups, :rooms do |t|
      # t.index [:room_group_id, :room_id]
      # t.index [:room_id, :room_group_id]
    end
  end
end
