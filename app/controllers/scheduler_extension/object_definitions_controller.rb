require_dependency "scheduler_extension/application_controller"

module SchedulerExtension
  class ObjectDefinitionsController < ApplicationController
    before_filter :get_main_app_models, only: [:index, :update]
    
    def index
      @object_definitions = ::SchedulerExtension::ObjectDefinition.all
    end
    
    def update
    end
    
    def new
      @object_definition = ::SchedulerExtension::ObjectDefinition.new
    end
    
  protected
  
    def get_main_app_models
      @available_object_definitions = "#{::AP::SchedulerExtension::Scheduler::Config.instance.latest_version.upcase}".constantize.constants
      if @available_object_definitions.blank?
        version = ::AP::SchedulerExtension::Scheduler::Config.instance.latest_version
        Dir.glob(Rails.root.join("app", "models", version, "*")).each do |f|
          "::#{version.upcase}::#{File.basename(f, '.*').camelize}".constantize.name 
        end

        @available_object_definitions = "#{::AP::SchedulerExtension::Scheduler::Config.instance.latest_version.upcase}".constantize.constants
      end
    end
    
  end
end
