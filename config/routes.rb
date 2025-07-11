Rails.application.routes.draw do
  get 'ratings/new'
  get 'ratings/create'
  get 'ratings/edit'
  get 'ratings/update'
  get 'ratings/destroy'
  get 'stores/index'
  get 'stores/show'
  get 'stores/dashboard'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Root route
  root "sessions#new"
  
  # Authentication routes
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/logout', to: 'sessions#destroy'
  
  # User routes
  resources :users do
    member do
      get :change_password
      patch :update_password
    end
    collection do
      get :dashboard
    end
  end
  
  # Store routes
  resources :stores do
    resources :ratings, except: [:show]
    member do
      get :dashboard
    end
  end
  
  # Admin routes
  namespace :admin do
    get 'stores/index'
    get 'stores/show'
    get 'stores/new'
    get 'stores/create'
    get 'stores/edit'
    get 'stores/update'
    get 'stores/destroy'
    get 'users/index'
    get 'users/show'
    get 'users/new'
    get 'users/create'
    get 'users/edit'
    get 'users/update'
    get 'users/destroy'
    get 'dashboard/index'
    get :dashboard
    resources :users
    resources :stores
    get :statistics
  end
  
  # Signup route
  get '/signup', to: 'users#new'
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end

