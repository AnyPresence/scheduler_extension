require 'test_helper'

class SchedulerTest < ActiveSupport::TestCase
  
  should "schedule with expired job" do
    future_time = Time.now + 30 
    AP::SchedulerExtension::Scheduler.expects(:query_objects)
    AP::SchedulerExtension::Scheduler.stubs(:expired?).returns(true)
    AP::SchedulerExtension::Scheduler.stubs(:add_to_queue)
    Resque.enqueue(LifecycleTriggeredSchedulerExtension, {options: {future_time: future_time.to_s}})
  end
  
  should "not schedule with non expired job" do
    future_time = Time.now + 30 
    ::AP::SchedulerExtension::Scheduler.expects(:add_to_queue).once
    ::AP::SchedulerExtension::Scheduler.stubs(:expired?).returns(false)
    Resque.enqueue(LifecycleTriggeredSchedulerExtension, {options: {future_time: future_time.to_s}})
  end
  
  should "perform scheduled task" do
    future_time = Time.now + 30 
    options = HashWithIndifferentAccess.new({future_time: future_time})
    Resque.stubs(:enqueue).with(::SchedulerExtension::QueryObjectsWorker, anything(), anything());
    AP::SchedulerExtension::Scheduler.scheduler_perform(nil, options)
  end
  
end
