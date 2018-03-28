class TestCase < ActiveRecord::Base
  belongs_to :task

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