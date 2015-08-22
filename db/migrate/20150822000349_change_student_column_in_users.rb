class ChangeStudentColumnInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :student, :is_student
  end
end
