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
  resources :teams do
    member do
      get :following, :followers, :calendar, :team_stats
    end
    # カレンダーのイベントルート
    resources :events
  end
  resources :players do 
    member do
      get :message, :message_show, :edit_stats
      patch :update_stats
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts do
    # コメント機能用のルーティング
    resources :comments, except: [:index,:show] do
      # メンバールーティングを追加
      member do
        get :reply
      end
    end
  end
  resources :relationships,       only: [:create, :destroy]
  # RSSフィード用のルーティング
  resources :feeds, only: [:index], defaults: { format: :rss }
  # ActionCableを利用するため
  mount ActionCable.server => '/cable'
end
