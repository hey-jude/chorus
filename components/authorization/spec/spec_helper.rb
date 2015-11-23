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

require 'support/stub_solr'

require 'fixture_builder'
require 'support/fixture_builder'

Dir[Pathname.new(Authorization::Engine.root).join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.fixture_path = File.expand_path(File.join(Authorization::Engine.root, 'spec', 'fixtures'))

  config.before(:all) do
    self.class.set_fixture_class :events => Events::Base
    self.class.fixtures :all
  end

  config.use_transactional_fixtures = true

  config.include AuthHelper, :type => :controller
  config.include RocketPants::TestHelper, :type => :controller
  config.include RocketPants::TestHelper, :type => :request
end