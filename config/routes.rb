Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "pages#home"
  get "/about", to: "pages#about"
  # get "/listing", to: "pages#sell"
  get "/listings/index", to: "listings#index"
  get "/listings/new", to: "listings#new", as: "listing_new"
  post "/listings/new", to: "listings#create", as: "listing_create"
  get "/listings/:id", to: "listings#show", as: "listing_show"
  resources :transactions, only: [:create]
  # get "/listings/"
end