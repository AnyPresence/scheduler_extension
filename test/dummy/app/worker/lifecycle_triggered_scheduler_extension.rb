# Worker file for extension.
class LifecycleTriggeredSchedulerExtension
  @queue = :scheduler_extension
  
  # Perform asynchronous task.
  # Parameters:
  #   +klass_data+:: hash of options: 
  #    :interval, interval to run task
  #    :data, array of hashes, e.g. {:object_klazz => "Outage", :query_scope => "exact_match", :query_params => {}, :extension_method_name => "web_service_perform", :options_for_extension => {}} 
  def self.perform(klazz_data) 
    ::AP::SchedulerExtension::Scheduler.scheduler_perform(klazz_data) 
  end
  
end