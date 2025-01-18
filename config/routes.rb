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
    resources :posts do
      resource :favorite, only: [:create, :destroy]
      resources :post_comments, only: [:create, :destroy]
    end
    get "/mypage", to: "users#mypage"
    resources :users, only: [:show, :edit, :update, :destroy]
    get "/search", to: "searches#search"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end