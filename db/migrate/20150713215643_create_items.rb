class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.integer :quantity
      t.string :type
      t.references :organization, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
