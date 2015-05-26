Worklet::Engine.routes.draw do

  resources :worklet do
    get 'index', on: :collection
    get 'list', on: :collection
  end

end
