require_dependency "scheduler_extension/application_controller"

module SchedulerExtension
  class ObjectDefinitionsController < ApplicationController
    before_filter :get_main_app_models, only: [:index, :update]
    before_filter :get_available_extensions, only: [:edit, :new]

    def index
      @object_definitions = ::SchedulerExtension::ObjectDefinition.all
    end
    
    def edit
      @object_definition = ::SchedulerExtension::ObjectDefinition.find(params[:id])
    end
    
    def show
      @object_definition = ::SchedulerExtension::ObjectDefinition.find(params[:id])
    end
    
    def new
      @object_definition = ::SchedulerExtension::ObjectDefinition.new      
      @object_definition.name = params[:name] || ""
    end
    
    def destroy
      @object_definition = ::SchedulerExtension::ObjectDefinition.find(params[:id])      
      @object_definition.destroy

      respond_to do |format|
        format.html { redirect_to object_definitions_url }
        format.json { head :no_content }
      end
    end
    
    def update
      @object_definition = ::SchedulerExtension::ObjectDefinition.find(params[:id])
      params[:object_definition][:extensions] ||= []
      
      extensions = params[:object_definition][:extensions]
      
      respond_to do |format|
        if @object_definition.update_attributes(params[:object_definition].except(:extensions))
          if !extensions.blank?
            extensions.each do |ext|
              if @object_definition.extensions.where(name: ext[:name]).empty?
                @object_definition.extensions << ::SchedulerExtension::Extension.new(name: ext[:name])
              end
            end
          end
          
          extension_names = extensions.map {|m| m[:name]}
          disabled_extensions = []
          @object_definition.extensions.each do |ext|
            if !extension_names.include?(ext.name)
              disabled_extensions << ext.id
            end
          end
          disabled_extensions.each {|m| ::SchedulerExtension::Extension.find(m).delete }
          
          format.html { redirect_to object_definitions_url, notice: 'Successfully created. Configure extensions by selecting them.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @object_definition.errors, status: :unprocessable_entity }
        end
      end
    end
    
    def create
      @object_definition = ::SchedulerExtension::ObjectDefinition.new(params[:object_definition].except(:extensions))

      if !params[:object_definition][:extensions].blank?
        params[:object_definition][:extensions].each do |ext|
          @object_definition.extensions << ::SchedulerExtension::Extension.new(name: ext[:name])
        end
      end
      
      respond_to do |format|
        if @object_definition.save
        
          format.html { redirect_to object_definitions_url, notice: 'Successfully created. Configure extensions by selecting them.' }
          format.json { render json: @object_definition, status: :created, location: @object_definition }
        else
          format.html { render action: "new" }
          format.json { render json: @object_definition.errors, status: :unprocessable_entity }
        end
      end
    end
    
    def manually_execute_tasks
      @object_definitions = ::SchedulerExtension::ObjectDefinition.all

      @count = ::SchedulerExtension::ObjectDefinition.manually_execute_tasks(@object_definitions)
    end
    
  protected
  
    def get_main_app_models
      @available_object_definitions = "#{::AP::SchedulerExtension::Scheduler::Config.instance.latest_version.upcase}".constantize.constants
      if @available_object_definitions.blank?
        version = ::AP::SchedulerExtension::Scheduler::Config.instance.latest_version
        Dir.glob(Rails.root.join("app", "models", version, "*.rb")).each do |f|
          "::#{version.upcase}::#{File.basename(f, '.*').camelize}".constantize.name 
        end

        @available_object_definitions = "#{::AP::SchedulerExtension::Scheduler::Config.instance.latest_version.upcase}".constantize.constants
      end
      @available_object_definitions.delete(:Custom)
    end
  
    def get_available_extensions
      @available_extensions = ::AP.constants.map do |m| 
        if (!m.empty? && m != :SchedulerExtension)
          ext = ::SchedulerExtension::Extension.new(name: m.to_s)
          begin
            ext if !ext.json_config.blank? && !ext.json_config["model_configuration"]["object_definition_level_configuration"].blank?
          rescue
            Rails.logger.error "Unable to use #{ext.name}: #{$!.message}"
            nil
          end
        end 
      end
      @available_extensions = @available_extensions.compact
    end
    
  end
end
