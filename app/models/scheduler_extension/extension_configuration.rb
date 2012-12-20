module SchedulerExtension
  class ExtensionConfiguration
    include ActiveModel::MassAssignmentSecurity
    include Mongoid::Document
    
    belongs_to :extension
    
    field :name, type: String
    field :value, type: String
  end
end