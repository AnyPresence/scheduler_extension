require 'singleton'

module AP
  module SchedulerExtension
    module Scheduler
      @@job_unit = nil
      @@latest_version = nil
      
      # Creates the account.
      # +config+ configuration properties should contain
      def self.config_account(config={})
        config = HashWithIndifferentAccess.new(config)
        Config.instance.configuration ||= HashWithIndifferentAccess.new
        Config.instance.configuration = Config.instance.configuration.merge(config)
        
        # Start scheduler task with current time + interval
        interval = self.interval
        add_to_queue(Time.now + interval)
      end
      
      def self.add_to_queue(future_time=Time.now)
        ::Resque.enqueue(::LifecycleTriggeredSchedulerExtension, Config.instance.configuration)
      end
      
      def self.job
        interval = self.interval
        Config.instance.job_unit ||= ::SchedulerExtension::JobUnit.new(Time.now + interval)
      end
      
      # Creates jobs for various other extensions (e.g. sms, push)
      def self.scheduler_perform(options={})
        interval = Config.instance.configuration[:interval]
        Rails.logger.info "Fired scheduler job. Config: #{@@config.inspect}"
        options = HashWithIndifferentAccess.new(options)
        
        # Objects 
        options[:data].each do |data|
          ::Resque.enqueue(::SchedulerExtension::TriggeredScheduler, data[:object_klazz], data[:query_scope], data[:query_params], data[:extension_method_name], data[:options_for_extension])
        end

      end
      
      def self.interval
        Config.instance.configuration[:interval].blank? ? 0 : Config.instance.configuration[:interval].to_i
      end
      
      class Config
        include Singleton
        
        attr_accessor :latest_version, :configuration, :job_unit
      end
      
    end
  end
end