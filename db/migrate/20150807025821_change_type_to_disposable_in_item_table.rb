class ChangeTypeToDisposableInItemTable < ActiveRecord::Migration
  def change
    remove_column :items, :type
    add_column :items, :disposable, :boolean
  end
end
