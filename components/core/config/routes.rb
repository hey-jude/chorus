Rails.application.routes.draw do
  resource :log_archiver, :only => :show
end