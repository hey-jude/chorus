Admin::Engine.routes.draw do

#  root to: 'admin#index'

  resources :admin do
    get 'index', on: :collection
    get 'dashboard', on: :collection

  end

  resources :users
  resources :teams
  resources :data_sources

end
