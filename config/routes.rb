SchedulerExtension::Engine.routes.draw do
  post 'manually_execute_tasks' => 'object_definitions#manually_execute_tasks'

  resources :object_definitions do
    resources :extensions
  end

  root :to => "object_definitions#index"
end
