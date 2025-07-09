Rails.application.routes.draw do
  resources :products
  devise_for :users, controllers: {
    registrations: 'registrations'
  }

  # Cart routes
  resource :cart, only: [:show, :destroy] do
    post :add_item
    delete :remove_item
    delete :empty
  end

  root 'products#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
