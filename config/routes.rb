Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :cuvees
  resources :caves
  resources :degustations, except: %i[new create]
  resources :bouteilles, except: :show
  resources :bouteilles, only: :show do
    resources :degustation, only: %i[new create]
  end

end
