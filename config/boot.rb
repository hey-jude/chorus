require 'rubygems'
require 'rails/commands/server'

if ENV['RAILS_ENV'] == 'production' && File.exists?(File.expand_path('../../Gemfile-packaging', __FILE__))
  ENV['BUNDLE_GEMFILE'] = File.expand_path('../../Gemfile-packaging', __FILE__)
end

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

module Rails
  class Server
    def default_options
      super.merge({Port: 3002})
    end
  end
end
