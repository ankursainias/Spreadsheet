Rails.application.routes.draw do
  get 'users/new'
  get 'users/list'
  post 'users/create'
  root 'users#new'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
