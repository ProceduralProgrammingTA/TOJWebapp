module QueueServices
  class Forker
    attr_reader :pid
    def install_exit_handler(signal="KILL")
      at_exit do
        begin
          Process.kill(signal, @pid)
          Process.wait(@pid)
        rescue Errno::ESRCH, Errno::ECHILD
          # noop
        end
      end
    end

    def install_signal_handler
      [:INT, :QUIT].each do |signal|
        old_handler = Signal.trap(signal) {
          Process.kill(signal, @pid)
          Process.wait(@pid)
          old_handler.call
        }
      end
    end
  end
end
