# fork task runner process
QueueServices::Master.new.invoke unless defined? RAKE_RUNNING
