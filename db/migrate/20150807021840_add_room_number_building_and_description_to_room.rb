class AddRoomNumberBuildingAndDescriptionToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :number, :string
    add_column :rooms, :building, :string
    add_column :rooms, :description, :text
  end
end
