Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :caves
  resources :cuvees
  resources :bouteilles, except: %i[show update]
  resources :degustations, except: %i[new create]
  resources :cuvees, only: :show do
    resources :bouteilles, only: :update
  end
  resources :bouteilles, only: :show do
    resources :degustations, only: %i[new create]
  end
end
