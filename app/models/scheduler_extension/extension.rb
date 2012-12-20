module SchedulerExtension
  class Extension
    include ActiveModel::MassAssignmentSecurity
    include Mongoid::Document
    
    field :name, type: String
    
    belongs_to :object_definition
    has_many :extension_configurations, class_name: "::SchedulerExtension::ExtensionConfiguration"
    
    accepts_nested_attributes_for :extension_configurations, class_name: "::SchedulerExtension::ExtensionConfiguration"
  end
end