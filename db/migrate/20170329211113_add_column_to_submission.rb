class AddColumnToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :ta_check, :string
    add_column :submissions, :ta_comment, :string
  end
end
