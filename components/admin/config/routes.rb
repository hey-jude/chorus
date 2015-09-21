Admin::Engine.routes.draw do

#  root to: 'admin#index'

  resources :admin, :path => "config" do
    get 'index', on: :collection
    get 'dashboard', on: :collection
    get 'licence_info' , on: :collection
    get 'email_config', on: :collection
    get 'auth_config', on: :collection
    get 'general_settings', on: :collection
    get 'app_preferences', on: :collection
    get 'default_settings', on: :collection
    get 'workflow_editor_pref', on: :collection
    get 'manage_tags', on: :collection
    get 'default_settings', on: :collection
  end

  resources :users

  resources :teams do
    get 'manage_memberships' , on: :member
    get 'manage_roles' , on: :member
    get 'manage_scopes' , on: :member
    get 'manage_workspaces' , on: :member
    put 'update_memberships' , on: :member
    put 'update_scopes' , on: :member
    put 'update_roles' , on: :member
    put 'update_workspaces' , on: :member
  end

  resources :data_sources
  resources :roles
  resources :scopes
  resources :workspaces

end
