Admin::Engine.routes.draw do
  resources :roles, :only => [:index, :show]
  resources :users, :only => [:index, :show]
end