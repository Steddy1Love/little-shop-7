Rails.application.routes.draw do


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :merchants, only: [:show, :create] do
    member { get "dashboard"}
    resources :items, only: [:index, :show, :edit, :update], :controller => 'merchant_items'
    resources :invoices, only: [:index, :show], :controller => 'merchant_invoices'
  end

  resources :admin, only: [:index]
  namespace :admin do
    resources :merchants, only: [:index, :show, :edit, :update, :new, :create]
    resources :invoices, only: [:index, :show, :update]
  end
end