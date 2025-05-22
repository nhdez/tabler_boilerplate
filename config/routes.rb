Rails.application.routes.draw do
  root "main#dashboard"

  devise_for :users, controllers: {
    registrations: 'registrations'
  }
  
  # Custom Devise routes
  devise_scope :user do
    post 'users/remove_avatar', to: 'registrations#remove_avatar', as: :remove_avatar
    get 'users/waiting_for_verification', to: 'registrations#waiting_for_verification', as: :waiting_for_verification
  end
  
  # User verification routes
  get 'users/verify/:token', to: 'users#verify', as: :verify_user
  get 'admin/pending_verifications', to: 'users#pending_verifications', as: :pending_verifications

  # Admin routes
  get 'admin/dashboard', to: 'admin#dashboard', as: :admin_dashboard
  
  namespace :admin do
    resources :users do
      member do
        patch :toggle_block
      end
    end
    
    # Admin settings
    get 'settings', to: 'settings#index'
    patch 'settings/:id', to: 'settings#update', as: :update_setting
  end
  
  # Test email routes - only accessible by admins
  resources :test_emails, only: [:new, :create]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
