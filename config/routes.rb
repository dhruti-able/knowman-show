Rails.application.routes.draw do
  root "sessions#create"

  post "signup" => "users#create"
  post "signin" => "sessions#create"
  delete "signout" => "sessions#destroy"

  resources :halls do
    resources :shows do
      get :confirm
      get :cancel
      
      resources :reservations, only: [:create, :show, :index] do
        get :verify
      end
    end
  end
  

  resources :users
  resource :session, only: [:create, :destroy]
end
