require 'test_helper'

class SchedulerTest < ActiveSupport::TestCase
  
  should "schedule with expired job" do
    mock_job = mock('job')
    mock_job.expects(:expired?).returns(true)
    AP::SchedulerExtension::Scheduler.expects(:job).returns(mock_job)
    options = HashWithIndifferentAccess.new({ interval:  "20", data: [{object_klazz: "Outage"}] })
    AP::SchedulerExtension::Scheduler.expects(:scheduler_perform).with(equals(options))
    
    Resque.enqueue(LifecycleTriggeredSchedulerExtension, options)
  end
  
  should "not schedule with non expired job" do
    mock_job = mock('job')
    mock_job.expects(:expired?).returns(false)
    AP::SchedulerExtension::Scheduler.expects(:job).returns(mock_job)
    Resque.enqueue(LifecycleTriggeredSchedulerExtension, {interval: "20", data: [{object_klazz: "Outage"}]})
  end
  
  should "perform scheduled task" do
    #SchedulerExtension::TriggeredScheduler.expects(:perform)
    options = HashWithIndifferentAccess.new({ interval:  "20", data: [{object_klazz: "Outage"}] })
    AP::SchedulerExtension::Scheduler.scheduler_perform(options)
  end
  
end
