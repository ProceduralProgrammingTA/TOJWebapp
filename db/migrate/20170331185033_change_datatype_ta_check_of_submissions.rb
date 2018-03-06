class ChangeDatatypeTaCheckOfSubmissions < ActiveRecord::Migration
  def change
    change_column(:submissions, :ta_check, :integer, default: 0)
  end
end
