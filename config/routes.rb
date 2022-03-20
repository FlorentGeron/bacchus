Rails.application.routes.draw do
  get 'degustations/new'
  get 'degustations/create'
  get 'degustations/edit'
  get 'degustations/delete'
  get 'degustations/update'
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
