module SchedulerExtension
  class ObjectDefinition
    include ActiveModel::MassAssignmentSecurity
    include Mongoid::Document
    include Mongoid::Timestamps
    
    validates :name, presence: true, uniqueness: true
    
    field :name, type: String
    field :query_scope, type: String
    has_many :extensions, class_name: "::SchedulerExtension::Extension"
    
    accepts_nested_attributes_for :extensions, class_name: "::SchedulerExtension::Extension"
    
    scope :has_name, ->(n) { where(:name => n) }
    
    def self.manually_execute_tasks(object_definitions)
      # For each object, get all the objects using its query scope and place it into 
      # a queue
      latest_version = ::AP::SchedulerExtension::Scheduler::Config.instance.latest_version
      Rails.logger.info "Running tasks for #{object_definitions.count} objects."
      object_definitions.each do |object|
        query_scope = object.query_scope
        extensions = object.extensions
        
        klazz = "::#{latest_version.upcase}::#{object.name}".constantize
        if query_scope.blank?
          Rails.logger.error("Need a query scope for #{klazz.to_s}")
          return
        end
        objects = klazz.respond_to?(query_scope.to_sym) ? klazz.send(query_scope.to_sym) : []
        Rails.logger.info("Will execute tasks for #{objects.count} #{klazz.to_s} objects")
        
        # Place objects into their respective queues
        objects.each do |object_to_queue|
          extensions.each do |extension|
            next if extension.blank?
            options = {}
            extension.extension_configurations.each do |config|
              options[config.name.to_sym] = config.value
            end
            Resque.enqueue("LifecycleTriggered#{extension.name}".constantize, {"object_instance_id" => object_to_queue.id, "klass_name" => object_to_queue.class.name, "options" => options })
          end
        end
      end 
    end
  end
end