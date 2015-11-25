Admin::Engine.routes.draw do
  root to: 'dashboard#index'
  resource :license, :only => [:show]
end