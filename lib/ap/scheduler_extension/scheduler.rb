require 'singleton'

module AP
  module SchedulerExtension
    module Scheduler
      @@latest_version = nil

      # Creates the account.
      # +config+ configuration properties should contain
      def self.config_account(config={})
        config = HashWithIndifferentAccess.new(config)
        Config.instance.configuration ||= HashWithIndifferentAccess.new
        Config.instance.configuration.merge!(config)

        # Start scheduler task with current time + interval
        interval = self.interval

        Config.instance.configuration.merge!({:interval => interval})

        future_time = Time.now + interval
        if !Config.instance.configuration[:disabled]
          add_to_queue(future_time)
        else
          Rails.logger.info "The extension has been disabled..."
        end
      end

      def self.expired?(future_time)
        future_time = future_time.is_a?(Time) ? future_time : Time.parse(future_time)
        (Time.now - future_time).to_i > 0
      end

      def self.add_to_queue(future_time=Time.now+interval)
        if expired?(future_time)
           future_time = Time.now + interval
           Rails.logger.info "Next time to expire is: #{future_time.to_s}"
        end

        Resque.remove_queue("scheduler_extension")
        ::Resque.enqueue(::LifecycleTriggeredSchedulerExtension, {options: {future_time: future_time.to_s}})
      end

      # Creates jobs for various other extensions (e.g. sms, push)
      def self.scheduler_perform(object_instance, options={})
        options = HashWithIndifferentAccess.new(options)
        future_time = options[:future_time]

        if !Config.instance.configuration[:disabled]
          ::Resque.enqueue(::SchedulerExtension::QueryObjectsWorker, nil, future_time)
        end
      end

      def self.query_objects
        ::SchedulerExtension::ObjectDefinition.manually_execute_tasks(::SchedulerExtension::ObjectDefinition.all)
      end

      # Returns interval in seconds
      def self.interval
        _interval =  ENV['AP_SCHEDULER_INTERVAL'] || Config.instance.configuration[:interval]
        if _interval.blank?
          60
        else
          _interval.to_i
        end
      end

      class Config
        include Singleton

        attr_accessor :latest_version, :configuration
      end

    end
  end
end