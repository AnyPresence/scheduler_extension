Rails.application.routes.draw do

  resources :outages


  mount SchedulerExtension::Engine => "/scheduler_extension"
end
