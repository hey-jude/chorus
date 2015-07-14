Admin::Engine.routes.draw do

#  root to: 'admin#index'

  resources :admin do
    get 'index', on: :collection
    get 'dashboard', on: :collection

    #get 'workspace_grid', on: :collection
    #get 'workspace_list', on: :collection

  end

  # resources :workspace do
  #   get 'index', on: :collection
  #   get 'list', on: :collection
  #   get 'comments', on: :collection
  # end

end
