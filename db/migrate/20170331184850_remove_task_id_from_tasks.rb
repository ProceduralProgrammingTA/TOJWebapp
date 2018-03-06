class RemoveTaskIdFromTasks < ActiveRecord::Migration
  def change
    remove_column(:tasks, :task_id)
  end
end
