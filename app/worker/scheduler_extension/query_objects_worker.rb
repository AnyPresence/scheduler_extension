class ::SchedulerExtension::QueryObjectsWorker
  @queue = :query_objects_worker
  
  def self.perform(klass_data, future_time=nil)  
    if ::AP::SchedulerExtension::Scheduler.expired?(future_time)
       ::AP::SchedulerExtension::Scheduler.query_objects
       Rails.logger.debug "Time has expired!"
    else
      Rails.logger.debug "Time has not expired!"
    end
    
    # Place timer back in lifecycle_triggered_scheduler_extension queue with a future time.
    ::AP::SchedulerExtension::Scheduler.add_to_queue(future_time)
  end
   
end