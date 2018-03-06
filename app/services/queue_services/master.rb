module QueueServices
  class Master < Forker
    LOCK_FILE = 'queuemaster.lock'
    # 2以上で有効に動かすにはdocker-machineを複数立てて、docker run時にそれを指定しなければならないみたい
    # そうしないと同じmachine = コアに並列数だけのrunが走って意味がなくなる
    # あとDBの接続がbusyになって死ぬ、timeout 50秒にしても待たずに例外を吐きやがるので意味不明
    # この辺をきちんと使うならMySQLにしないとダメかも
    #require 'etc'
    NUM_WORKERS = 1 #[Etc.nprocessors-1, 1].max
    def invoke
      forked = false
      begin
        File.open(LOCK_FILE, 'r+') do |file|
          forked = get_lock_and_fork file
        end
      rescue Errno::ENOENT => e
        File.open(LOCK_FILE, 'w+') do |file|
          forked = get_lock_and_fork file
        end
      end

      if @pid
        if forked
          install_exit_handler "TERM"
          install_signal_handler
        end
      else
        run
      end
    end

    def get_lock_and_fork(file)
      locked = file.flock(File::LOCK_EX | File::LOCK_NB)
      @pid = file.read.to_i
      if locked and !(@pid != 0 and (process_running? @pid))
        ActiveRecord::Base.clear_all_connections!
        @pid = fork
        if @pid
          ActiveRecord::Base.establish_connection
          file.truncate 0
          file.puts @pid
        end
        true
      else
        false
      end
    end

    def process_running?(pid)
      Process.getpgid(pid)
      true
    rescue
      false
    end

    def running?
      if File.exist?(LOCK_FILE)
        File.open(LOCK_FILE) do |file|
          pid = file.read.to_i
          process_running? pid
        end
      else
        false
      end
    end

    def run
      at_exit do
        File.delete LOCK_FILE if File.exist? LOCK_FILE
      end
      workers = NUM_WORKERS.times.map {|n|
        Runner.new n
      }
      workers.each &:start
      loop do
        sleep 10
        workers.each {|w|
          if Process.waitpid(w.pid, Process::WNOHANG)
            w.start
          end
        }
      end
    end
  end
end
