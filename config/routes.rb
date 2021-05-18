Rails.application.routes.draw do

  # Authentication Controller
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
  put "/cart", to: "carts#add_to_cart", as: "cart_add"

  # Transactions
  post "/checkout", to: "transactions#create", as: "checkout"
  get "/checkout/success", to: "transactions#success"
  get "/checkout/cancel", to: "transactions#cancel"

  # Search functionality
  get '/search' => 'pages#search', :as => 'search_page'
  
end