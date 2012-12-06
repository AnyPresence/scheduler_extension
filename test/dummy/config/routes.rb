Rails.application.routes.draw do

  mount SchedulerExtension::Engine => "/scheduler_extension"
end
