Admin::Engine.routes.draw do

#  root to: 'admin#index'

  resources :admin do
    get 'index', on: :collection
    get 'dashboard', on: :collection
  end

  resources :users

  resources :teams do
    get 'manage_memberships' , on: :member
    get 'manage_roles' , on: :member
    get 'manage_scopes' , on: :member
    get 'manage_workspaces' , on: :member
  end

  resources :data_sources
  resources :roles
  resources :chorus_scopes
  resources :workspaces

end
