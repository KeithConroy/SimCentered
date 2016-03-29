class CreateRoomGroups < ActiveRecord::Migration
  def change
    create_table :room_groups do |t|
      t.string :title
      t.references :organization, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
