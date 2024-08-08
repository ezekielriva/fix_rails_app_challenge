Rails.application.routes.draw do
  devise_for :users
  resources :orders
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :products
end
