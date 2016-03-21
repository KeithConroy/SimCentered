class CreateJoinTableEventsCourses < ActiveRecord::Migration
  def change
    create_join_table :events, :courses do |t|
      # t.index [:event_id, :course_id]
      # t.index [:course_id, :event_id]
    end
  end
end
