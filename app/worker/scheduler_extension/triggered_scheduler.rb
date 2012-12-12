# There should only be one of these jobs in the queue.
module SchedulerExtension
  class TriggeredScheduler
    @queue = :triggered_scheduler
        
    def self.perform(object_klazz, query_scope_name, query_params, future_time, extension_method_to_fire, options_for_extension = {})
      Rails.logger.info "performing... at: #{Time.now}"
      job_unit = ::SchedulerExtension::JobUnit.new(future_time)
      klazz = "::V1::#{object_klazz}".constantize
      objects = klazz.send(query_scope_name.to_sym)
      objects.each do |object|
        klazz.send(extension_method_to_fire.to_sym, object, options_for_extension)
      end
      interval = options[:interval].blank? ? 0 : options[:interval].to_i
      ::AP::SchedulerExtension::Scheduler::add_to_queue(Time.now + interval)
    end
    
  end
end