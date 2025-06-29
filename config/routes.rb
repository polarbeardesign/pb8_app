Rails.application.routes.draw do
  resources :page_contents
      get "about" => "page_contents#about"
      get "services" => "page_contents#services"
      get "portfolio" => "page_contents#portfolio"
      get "contact" => "page_contents#contact"
      get "home" => "page_contents#home"

  resources :reminders
  resources :work_periods
  resources :tasks
  resources :invoices
  resources :customers
  resources :notes
  resources :note_categories
  resource :session
  resources :passwords, param: :token
  resources :roles
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
   root "home"
end
