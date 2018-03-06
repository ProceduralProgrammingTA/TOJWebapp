class AddIndexes < ActiveRecord::Migration
  def change
    add_index "submissions", "created_at"
    add_index "submissions", "task_id"
    add_index "submissions", "student_id"
  end
end
