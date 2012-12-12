class Outage
  include Mongoid::Document
  include Mongoid::Timestamps
  include AP::SchedulerExtension::Scheduler
  
  field :"title", type: String
  
  def save
    super
    Rails.logger.info "Sending scheduler job"
    scheduler_perform(self, {})
    true
  end
end
