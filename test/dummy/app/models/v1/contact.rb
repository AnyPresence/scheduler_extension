class V1::Contact
  include Mongoid::Document
  include Mongoid::Timestamps
  include AP::SchedulerExtension::Scheduler
  
end