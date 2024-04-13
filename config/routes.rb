Rails.application.routes.draw do


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :merchants, only: [:show] do
    member { get "dashboard"}
    resources :items, only: [:index]
    resources :invoices, only: [:index, :show]
  end

  
  resources :admin, only: [:index]
  namespace :admin do
    resources :merchants, only: [:index, :show, :edit, :update]
    resources :invoices, only: [:index]
  end
end