class AddInstructorToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :instructor, index: true
  end
end
