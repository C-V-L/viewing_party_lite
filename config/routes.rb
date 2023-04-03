Rails.application.routes.draw do

  root "landing#index"
  get "register", to: "users#new"
  post "register", to: "users#create"
  
  resources :users, only: [:show, :new, :create] do
    get "/discover", to: "discover#index"
    # post "/register", to: "users#login"

    resources :movies, only: [:show, :index]
  end

  get "/users/:user_id/movies/:movie_id/viewing-party/new", to: "viewing_parties#new"
  post "/users/:user_id/movies/:movie_id/viewing-party/new", to: "viewing_parties#create"
end
