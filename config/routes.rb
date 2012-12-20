SchedulerExtension::Engine.routes.draw do
  match 'settings' => 'settings#settings'
  post 'manually_execute_tasks' => 'object_definitions#manually_execute_tasks'
  
  resources :object_definitions do 
    resources :extensions
  end
end
