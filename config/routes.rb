Rails.application.routes.draw do

  # Authentication
  devise_for :users

  # Pages Controller
  root to: "pages#home"
  get "/about", to: "pages#about"
  
  # Listings Controller
  get "/listings/index", to: "listings#index"
  get "/listings/new", to: "listings#new", as: "listing_new"
  post "/listings/new", to: "listings#create", as: "listing_create"
  get "/listings/:id", to: "listings#show", as: "listing_show"

  # Cart
  get "/cart", to: "carts#show"
  put "/cart/:cart_id/:listing_id", to: "carts#add_to_cart", as: "cart_add"
  put "/cart/:cartlisting_id", to: "carts#update", as: "cart_update"
  delete "/cart/:cartlisting_id", to: "carts#delete", as: "cart_delete"

  # Transactions
  post "/checkout", to: "transactions#create", as: "checkout"
  get "/checkout/success", to: "transactions#success"
  get "/checkout/cancel", to: "transactions#cancel"

  # Search functionality
  get '/search' => 'pages#search', :as => 'search_page'
  
end