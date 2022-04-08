Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :caves
  resources :cuvees
  resources :appellations, only: :index
  resources :bouteilles, except: %i[show new]
  resources :degustations, except: %i[index new create]
  resources :bouteilles, only: :new do
    get 'renderbuttons', to: 'bouteilles#renderbuttons'
  end
  get '/bouteilles/metrics', to: 'bouteilles#metrics', as: :metrics
  resources :bouteilles, only: :show do
    resources :degustations, only: %i[new index]
    post '/degustations/', to: 'degustations#create', as: :create_degustations
  end
end
