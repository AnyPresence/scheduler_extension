SchedulerExtension::Engine.routes.draw do
  match 'settings' => 'settings#settings'
  
  resources :object_definitions
end
