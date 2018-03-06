class AddFinishedToSubmissions < ActiveRecord::Migration
  def up
    add_column :submissions, :is_completed, :boolean, default: false
    Submission.update_all is_completed: true
  end

  def down
    change_table :submissions do |t|
      t.remove :is_completed
    end
  end
end
