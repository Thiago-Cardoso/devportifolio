Rails.application.routes.draw do
  root 'pages#home'
    devise_for :users
    resources :portfolios, except: :new do
    resources :tags, only: [:create, :destroy], param: :tag_id, controller: :portfolio_tags
    resources :blocks, only: [:index, :create, :destroy]
    resources :profiles, only: [:index, :update]
    resources :experiences, only: [:index, :create, :destroy]
    resources :educations, only: [:index, :create, :destroy]
    resources :skills, only: [:index, :create, :destroy]
    resources :hobbies, only: [:index, :create, :destroy]
    resources :languages, only: [:index, :create, :destroy]
  end
  resources :tags, only: :index
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
