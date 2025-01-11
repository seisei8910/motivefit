Rails.application.routes.draw do
  devise_for :users
  root to: "homes#top"
  get "/about", to: "homes#about"
  resources :posts do
    resources :post_comments, only: [:create, :destroy]
  end
  get "/mypage", to: "users#mypage"
  resources :users, only: [:show, :edit, :update, :destroy]
  get "/search", to: "searches#search"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end