module QueueServices
  class Runner < Forker
    def initialize(id)
      @id = id
      @submission = nil
    end

    def start
      ActiveRecord::Base.clear_all_connections!
      @pid = fork do
        ActiveRecord::Base.establish_connection
        loop do
          begin
            fetch
            sleep 3 unless @submission
          end until @submission
          run
        end
      end
      install_exit_handler
      install_signal_handler
    end

    def fetch
      @submission = Submission.where(status: 'Queued').limit(1).first
      if @submission
        runnable = false
        @submission.with_lock do
          if @submission.status == 'Queued'
            @submission.status = 'Running'
            @submission.save!
            runnable = true
          end
        end
        @submission = nil unless runnable
      end
    end

    def run
      task_title = SecureRandom.uuid
      task_id = @submission.task_id
      student_name = SecureRandom.uuid

      require 'open3'

      cmd = "docker run -v /data/submissions/#{@submission.id}:/#{student_name} -v /data/tasks/#{task_id}:/#{task_title}:ro 'gcc:latest' bash -c \"bash /#{task_title}/test.sh #{student_name} #{task_title}\""
      o, e, s = Open3.capture3(cmd)
      @submission.message = o.to_s + e.to_s
      @submission.message = @submission.message.gsub(/\r\n/, "\n") rescue "Invalid Output"
      @submission.status = begin
        case
          when @submission.message == "Invalid Output"; 'IO'
          when o.to_s.include?('Compile Error'); 'CE'
          when o.to_s.include?('Compile Warning'); 'CW'
          when o.to_s.include?('Runtime Error'); 'RE'
          when o.to_s.include?('NG');  'WA'
          when o.to_s.include?('TLE'); 'TLE'
          else 'AC'
        end
      end
      @submission.is_completed = true
      @submission.is_accepted = @submission.status == 'AC'
      @submission.save
    end
  end
end
