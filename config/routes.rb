Rails.application.routes.draw do
  get 'teams/new'

  root 'top_pages#home'
  get  '/contact', to: "top_pages#contact"
  resources :teams
end
