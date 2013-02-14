module SchedulerExtension
  class Extension
    include ActiveModel::MassAssignmentSecurity
    include Mongoid::Document
    
    field :name, type: String
    
    belongs_to :object_definition
    has_many :extension_configurations, class_name: "::SchedulerExtension::ExtensionConfiguration"
    
    accepts_nested_attributes_for :extension_configurations, class_name: "::SchedulerExtension::ExtensionConfiguration"
    
    def json_config
      n = name.slice(0, name.rindex("Extension"))
      klazz = "::AP::#{name}::#{n}".constantize
      if klazz.respond_to?(:json_config)
        return klazz.send(:json_config)
      else
        return nil
      end
    end
  end
end