require 'rubygems'
ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../dummy/config/environment", __FILE__)

require 'sunspot_matchers'
require 'rspec/rails'
require 'shoulda-matchers'

require 'timecop'
require 'rr'

FACTORY_GIRL_SEQUENCE_OFFSET = 44444
require 'factory_girl'
FactoryGirl.factories.clear
FactoryGirl.definition_file_paths = ["#{ENV['CHORUS_HOME']}/spec/factories"]
FactoryGirl.reload

Dir[Pathname.new(Authorization::Engine.root).join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.before :type => :controller do
    request.env['CONTENT_TYPE'] = "application/json"
  end

  config.use_transactional_fixtures = true

  config.before do
    Sunspot.session = SunspotMatchers::SunspotSessionSpy.new(Sunspot.session)
  end
  config.after do
    Sunspot.session = Sunspot.session.original_session if Sunspot.session.is_a? SunspotMatchers::SunspotSessionSpy
  end

  config.include SunspotMatchers
  config.include AuthHelper, :type => :controller
  config.include RocketPants::TestHelper, :type => :controller
end