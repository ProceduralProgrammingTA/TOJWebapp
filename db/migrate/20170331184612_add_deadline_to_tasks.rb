class AddDeadlineToTasks < ActiveRecord::Migration
  def change
    add_column(:tasks, :deadline, :datetime)
  end
end
