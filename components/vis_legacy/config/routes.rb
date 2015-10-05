Rails.application.routes.draw do
  resources :datasets, :only => [:show] do
    resources :visualizations, :only => [:create, :destroy]
  end

  post 'download_chart', :controller => 'image_downloads'
end
