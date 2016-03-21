class AddTimeZoneToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :time_zone, :string
  end
end
