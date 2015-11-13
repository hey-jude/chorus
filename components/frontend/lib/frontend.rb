require 'messengerjs-rails'
require 'codemirror-rails'
require 'mustache'
require 'sass-rails'
require 'compass-rails'
require 'handlebars_assets'
require 'rhino'
require 'uglifier'
require 'jquery-rails'

unless Rails.env.production?
  ENV['JASMINE_CONFIG_PATH'] = "#{ENV['CHORUS_HOME']}/components/frontend/spec/javascripts/support/jasmine.yml"
  require 'jasmine'
  require 'mizuno'
end

module Frontend
  require "frontend/engine"
end
