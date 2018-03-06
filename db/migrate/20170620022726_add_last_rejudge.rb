class AddLastRejudge < ActiveRecord::Migration
  def change
    add_column :tasks, :last_rejudge, :datetime, default: nil
  end
end
