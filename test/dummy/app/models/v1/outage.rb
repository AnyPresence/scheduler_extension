class V1::Outage
  include Mongoid::Document
  include Mongoid::Timestamps
  include AP::SchedulerExtension::Scheduler
  include AP::PushNotificationExtension::PushNotification
  
  field :"title", type: String
  
  def save
    super
    Rails.logger.info "Sending scheduler job"
    #scheduler_perform(self, {})
    true
  end
end
