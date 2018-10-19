Rails.application.routes.draw do
  root  'top_pages#home'
  get   '/contact',  to: "top_pages#contact"
  get   '/signup',   to: "players#new"
  post  '/signup',   to: "players#create"
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get    '/team/login',   to: 'team_sessions#new'
  post   '/team/login',   to: 'team_sessions#create'
  # delete '/team/logout',  to: 'team_sessions#destroy'
  resources :teams
  resources :players
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
end
