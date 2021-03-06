Rails.application.routes.draw do
  root "static_pages#home"
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/sign_up", to: "users#new"
  get "/log_in", to: "sessions#new"
  post "/sign_up", to: "users#create"
  post "/log_in", to: "sessions#create"
  delete "/log_out", to: "sessions#destroy"

  resources :users do
    resources :relationships, only: :index
  end
  resources :account_activations, only: :edit
  resources :password_resets, except: [:index, :show, :destroy]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
end
