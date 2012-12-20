#options = {}
# Start the timer thread
#Resque.enqueue(LifecycleTriggeredSchedulerExtension, {:interval => "20"})

begin
  ::AP::SchedulerExtension::Scheduler::config_account({:interval => 5})
rescue
  p "Unable to configure the extension: #{$!.message}"
  p $!.backtrace.join("\n")
end
