class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.string :code
      t.string :message
      t.boolean :is_accepted

      t.integer :student_id
      t.integer :task_id

      t.timestamps null: false
    end
  end
end
