Rails.application.routes.draw do
  mount Api::Engine => "/api"
  mount Frontend::Engine => "/"
end
