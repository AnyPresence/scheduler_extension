# Worker file for extension.
class LifecycleTriggeredPushNotificationExtension
  @queue = :push_notification_extension
  
  def self.perform(klass_data) 
    id = klass_data["object_instance_id"]
    klass = klass_data["klass_name"]
    # Extra parameters to the extension
    options = klass_data["options"]
    object = klass.constantize.where(:_id => id).first
    if !object.blank?
      object.execute_push_notification(object, options)
    else
      Rails.logger.error "Unable to trigger extension action for: #{id}"
    end
  end
   
end