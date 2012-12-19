module SchedulerExtension
  class ObjectDefinition
    include ActiveModel::MassAssignmentSecurity
    include Mongoid::Document
    include Mongoid::Timestamps
    
    validates :name, presence: true
    
    field :name, type: String
    field :query_scope, type: String
    field :extensions, type: Array
        
    scope :has_name, ->(n) { where(:name => n) }
  end
end