class CreateCameras < ActiveRecord::Migration
  def change
    create_table :cameras do |t|
      t.string :name
      t.string :ip_address
      t.string :serial_number
      t.references :organization, index: true, foreign_key: true
      t.references :room, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
