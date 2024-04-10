Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :admin do
    resources :merchants, only: [:index, :show]
  end

  resources :merchants, only: [:show] do
    member { get "dashboard"}
  end
end
