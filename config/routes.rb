Rails.application.routes.draw do

  # Authentication
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth' }

  # Pages Controller
  root to: "pages#home"
  get "/about", to: "pages#about"
  
  # Listings Controller
  resources :listings
  get "/user/listings", to: "listings#all"

  # Profiles
  get "/user/profile/new", to: "profiles#new"
  post "/user/profile/new", to: "profiles#create"
  get "/user/profile/show", to: "profiles#show"
  put "/user/profile/show", to: "profiles#update"
  
  # Sales and purchases
  get "/user/sales", to: "transactions#sales"
  get "/user/purchases", to: "transactions#purchases"

  # Cart
  get "/cart", to: "carts#index"
  put "/cart/:cart_id/:listing_id", to: "carts#add", as: "cart_add"
  put "/cart/:cartlisting_id", to: "carts#update", as: "cart_update"
  delete "/cart/:cartlisting_id", to: "carts#delete", as: "cart_delete"

  # Transactions
  get "/checkout/success", to: "transactions#success"
  post "/checkout", to: "transactions#create"
  get "/checkout/cancel", to: "transactions#cancel"
  post "/payments/webhook", to: "transactions#webhook"

  # Search functionality
  get '/search' => 'pages#search', as: 'search_page'
  
end