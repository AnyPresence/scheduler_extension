require_dependency "scheduler_extension/application_controller"

module SchedulerExtension
  class ExtensionsController < ApplicationController
    before_filter :get_extension_object_configurations, only: [:edit]
    
    def edit
      @object_definition = ::SchedulerExtension::ObjectDefinition.find(params[:object_definition_id])
      @extension = @object_definition.extensions.find(params[:id])
      
      if @extension.extension_configurations.blank?
        if !@extension_json.blank?
          @extension_json["model_configuration"]["object_definition_level_configuration"].keys.each do |object_level_config|
            ext_config = ::SchedulerExtension::ExtensionConfiguration.new(name: object_level_config)
            @extension.extension_configurations << ext_config
          end
        else
          Rails.logger.error "Unable to configure extension. No json configuration information available."
        end
      end
    end
    
    def update
      @object_definition = ::SchedulerExtension::ObjectDefinition.find(params[:object_definition_id])
      @extension = @object_definition.extensions.find(params[:id])
      
      if @extension.update_attributes(params[:extension])
        redirect_to object_definitions_path
      else
        render 'edit'
      end
    end
    
  protected
    def get_extension_object_configurations
      object_definition = ::SchedulerExtension::ObjectDefinition.find(params[:object_definition_id])
      @extension = object_definition.extensions.find(params[:id])
      
      ext_name = @extension.name
      name = ext_name.slice(0, ext_name.rindex("Extension"))
      klazz = "::AP::#{ext_name}::#{name}".constantize
      @extension_json = klazz.send(:json_config) if klazz.respond_to?(:json_config)
      
    end
  end
end
