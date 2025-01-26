Rails.application.routes.draw do
  devise_for :admin, skip: [:registrations, :password], controllers: {
    sessions: 'admin/sessions'
  }

  namespace :admin do
    get 'dashboards', to: 'dashboards#index'
    resources :users, only: [:show, :destroy]
  end

  scope module: :public do
    devise_for :users
    root to: "homes#top"
    get "/about", to: "homes#about"
    get "/follow_feed", to: "posts#follow_feed"
    resources :posts do
      resource :favorite, only: [:create, :destroy]
      resources :post_comments, only: [:create, :destroy]
    end
    get "/mypage", to: "users#mypage"
    resources :users, only: [:show, :edit, :update, :destroy] do
      member do
        get :favorite_posts
      end
      resource :relationships, only: [:create, :destroy]
        get "followings" => "relationships#followings", as: "followings"
        get "followers" => "relationships#followers", as: "followers"
    end
    get "/search", to: "searches#search"
    resources :messages, only: [:create]
    resources :rooms, only: [:create, :index, :show]
    resources :notifications, only: [:update]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end