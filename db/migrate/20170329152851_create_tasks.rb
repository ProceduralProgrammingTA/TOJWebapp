class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :task_id
      t.string :title
      t.string :description

      t.timestamps null: false
    end
  end
end
