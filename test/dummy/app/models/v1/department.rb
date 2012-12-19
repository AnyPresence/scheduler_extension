class V1::Department
  include Mongoid::Document
  include Mongoid::Timestamps
  include AP::SchedulerExtension::Scheduler
  
end