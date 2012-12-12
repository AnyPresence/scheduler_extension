module AP
  module SchedulerExtension
    module Scheduler
      @@config = HashWithIndifferentAccess.new
      
      # Creates the account.
      # +config+ configuration properties should contain
      def self.config_account(config={})
        if config.empty?
          raise "Nothing to configure!"
        end
        config = HashWithIndifferentAccess.new(config)
        
        @@config.merge!(config)
        
        # Get extensions to fire
        extensions_to_trigger = @@config[:extension_to_trigger]
        
        # Start scheduler task with current time + interval
        interval = @@config[:interval].blank? ? 0 : @@config[:interval].to_i
        add_to_queue(Time.now + interval)
      end
      
      def self.add_to_queue(future_time=Time.now)
        ::Resque.enqueue(::SchedulerExtension::TriggeredScheduler, future_time, @@config)
      end
      
      # Creates jobs for various other extensions (e.g. sms, push)
      def scheduler_perform(object_instance, options={})
        interval = @@config[:interval]
        Rails.logger.info "Fired scheduler job. #{@@config.inspect}"
        options = HashWithIndifferentAccess.new(options)
      end              
      
    end
  end
end