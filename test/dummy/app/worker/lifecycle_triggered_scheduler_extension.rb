# Worker file for extension.
class LifecycleTriggeredSchedulerExtension
  @queue = :scheduler_extension
  
  # Perform asynchronous task.
  # Parameters:
  #   +klass_data+:: hash of options: 
  #    :interval, interval to run task
  #    :data, array of hashes, e.g. {:object_klazz => "Outage", :query_scope => "exact_match", :query_params => {}, :extension_method_name => "web_service_perform", :options_for_extension => {}} 
   def self.perform(klass_data) 
    interval = klass_data[:interval]
    job = AP::SchedulerExtension::Scheduler.job
    if job.expired?
      AP::SchedulerExtension::Scheduler.scheduler_perform(klass_data) 
    else
      interval = AP::SchedulerExtension::Scheduler.interval
      AP::SchedulerExtension::Scheduler.add_to_queue(Time.now + interval) unless Rails.env.test?
    end
    true
  end
  
end