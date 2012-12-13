module AP
  module SchedulerExtension
    module Scheduler
      @@config = HashWithIndifferentAccess.new
      @@job_unit = nil
      
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
        interval = self.interval
        add_to_queue(Time.now + interval)
      end
      
      def self.add_to_queue(future_time=Time.now)
        ::Resque.enqueue(::LifecycleTriggeredSchedulerExtension, @@config)
      end
      
      def self.job
        interval = self.interval
        @@job_unit || ::SchedulerExtension::JobUnit.new(Time.now + interval)
      end
      
      # Creates jobs for various other extensions (e.g. sms, push)
      def self.scheduler_perform(options={})
        interval = @@config[:interval]
        Rails.logger.info "Fired scheduler job. Config: #{@@config.inspect}"
        options = HashWithIndifferentAccess.new(options)
        
        # Objects 
        # def self.perform(object_klazz, query_scope_name, query_params, future_time, extension_method_to_fire, options_for_extension = {})
        options[:data].each do |data|
          ::Resque.enqueue(::SchedulerExtension::TriggeredScheduler, data[:object_klazz], data[:query_scope], data[:query_params], data[:extension_method_name], data[:options_for_extension])
        end
        
        
      end
      
      def self.interval
        @@config[:interval].blank? ? 0 : @@config[:interval].to_i
      end              
      
    end
  end
end