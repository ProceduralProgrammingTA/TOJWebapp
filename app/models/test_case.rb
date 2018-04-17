class TestCase < ActiveRecord::Base
  belongs_to :task

  validates_uniqueness_of :file_name, scope: :task_id

  def content
    file_path = "/data/tasks/#{self.task_id}/#{self.file_name}"
    @content = ''
    unless self.file_name.blank?
      File.open(file_path, 'r') do |f|
        @content = f.read()
      end
    end
  end
end