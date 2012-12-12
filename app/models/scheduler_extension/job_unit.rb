module SchedulerExtension
  class JobUnit
    include ActiveModel::MassAssignmentSecurity
    include Mongoid::Document
    include Mongoid::Timestamps
    
    attr_reader :future_time_to_run
    
    def initialize(future_time_to_run)
      @future_time_to_run = future_time_to_run
    end
    
    def expired?
      (Time.now - future_time_to_run).round < 0
    end
    
  end
end