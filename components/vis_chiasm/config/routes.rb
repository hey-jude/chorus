Rails.application.routes.draw do
  resources :datasets, :only => [:show] do
    resource :chiasm_api_datasets, :only => [] do
      get 'show_column_data'
      get 'show_data'
    end
  end

  post 'download_chart', :controller => 'image_downloads'
end
