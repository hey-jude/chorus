Frontend::Engine.routes.draw do
  root to: 'root#index'

  namespace :import_console do
    resources :imports, :only => :index
  end
end
