Rails.application.routes.draw do

  # KT TODO, see: https://github.com/alpinedatalabs/adl/pull/914
  mount Api::Engine => "/"
  namespace :api, api_scope: true do
    mount Api::Engine => "/", as: 'api'
  end

  mount Frontend::Engine => "/"

  mount Admin::Engine => "/admin"
end
