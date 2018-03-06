class CreateTestCases < ActiveRecord::Migration
  def change
    create_table :test_cases do |t|
      t.string :file_name
      t.string :content
      t.string :memo

      t.integer :task_id

      t.timestamps null: false
    end
  end
end
