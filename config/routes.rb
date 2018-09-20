Rails.application.routes.draw do
  root 'pages#home'
  devise_for :users
  resources :portfolios, except: :new do
    resources :tags, only: [:create, :destroy], param: :tag_id, controller: :portfolio_tags
  end
  resources :tags, only: :index
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
