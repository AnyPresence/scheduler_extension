# Queue with jobs from timer queue.
module SchedulerExtension
  class TriggeredScheduler
    @queue = :triggered_scheduler
        
    def self.perform(object_klazz, query_scope_name, query_params, future_time, extension_method_to_fire, options_for_extension = {})
      Rails.logger.info "performing... at: #{Time.now}"
      klazz = "::V1::#{object_klazz}".constantize
      
      if !query_scope_name.blank?
        objects = klazz.send(query_scope_name.to_sym)
        objects.each do |object|
          klazz.send(extension_method_to_fire.to_sym, object, options_for_extension)
        end
      end

    end
    
  end
end