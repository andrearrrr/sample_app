Rails.application.routes.draw do

  get 'password_reset/new'
  get 'password_reset/edit'

  get '/update_awards' => 'picks#update_awards', :as => 'update_awards'

  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contacts', to: 'contacts#new'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get '/players', to: 'players#index'
  get '/players/test', to: 'players#test'
  get '/players/:id', to: 'players#show', as: "player"

  resources :users do
    member do
      get :outgoing_friends, :incoming_friends, :friends
    end
  end
  resources :relationships
  resources :picks
  resources :account_activations, only: [:edit]
  resources :password_resets,    only: [:new, :create, :edit, :update]
  get '/posts/:id', to: 'posts#index', as: 'post'
  get '/posts/friends/:id', to: 'posts#friends', as: 'post_friends'
  resources :posts, only: [:create, :destroy]
  resources :contacts, only: [:new, :create]
  resources :groups do
    get 'join', to: :create, controller: 'memberships'
    get 'leave', to: :destroy, controller: 'memberships'
  end

  root 'static_pages#home'

 
end
