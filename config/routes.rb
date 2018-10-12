Rails.application.routes.draw do
  root  'top_pages#home'
  get   '/contact', to: "top_pages#contact"
  get   '/signup',  to: "players#new"
  post  '/signup',  to: "players#create"
  resources :teams
  resources :players
end
