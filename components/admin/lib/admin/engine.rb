require 'rubygems'
require 'gretel'
require 'jquery-ui-rails'

module Admin
  class Engine < ::Rails::Engine
    isolate_namespace Admin
  end
end
