class AddIsPublic < ActiveRecord::Migration
  def up
    add_column :tasks, :is_public, :boolean, default: false
    Submission.update_all is_completed: false
  end

  def down
    change_table :tasks do |t|
      t.remove :is_public
    end
  end
end
