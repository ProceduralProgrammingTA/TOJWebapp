class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :task_title
      t.string :file_name
      t.string :student_comment
      t.string :ta_comment

      t.integer :student_id

      t.timestamps null: false
    end
  end
end
