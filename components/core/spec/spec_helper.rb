if ENV["COVERAGE"] == "true"
  require 'simplecov'

  SimpleCov.start do
    add_filter "/spec/" # Ignore coverage for _spec.rb files because they are always 100%
  end
end

require 'rubygems'
ENV["RAILS_ENV"] ||= 'test'
ENV["LOG_LEVEL"] = '3'

require File.expand_path("../dummy/config/environment", __FILE__)

require 'sunspot_matchers'
require 'rspec/rails'
require 'rspec/autorun'
require 'paperclip/matchers'
# require 'rspec_api_documentation'
# require 'rspec_api_documentation/dsl'
require 'fixture_builder'
require 'shoulda-matchers'
require 'factory_girl'
require 'faker'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Core::Engine.root.join("spec/support/**/*.rb")].each { |f| require f unless f.match /fixture_builder/ }
Dir[Pathname.new(ENV['CHORUS_HOME']).join("spec/support/**/*.rb")].each { |f| require f unless f.match /fixture_builder/ }

require 'external_service_detector'

SPEC_PASSWORD = 'password'

# If this offset is not here and you have pre-built fixture_builder, the ids/usernames/etc of new
# models from Factory Girl will clash with the fixtures
FACTORY_GIRL_SEQUENCE_OFFSET = 44444
FactoryGirl.factories.clear
# KT: see https://github.com/thoughtbot/factory_girl_rails/pull/42
FactoryGirl.definition_file_paths = ["#{ENV['CHORUS_HOME']}/spec/factories"]
FactoryGirl.reload

require 'support/fixture_builder'

silence_warnings { FACTORY_GIRL_SEQUENCE_OFFSET = 0 }

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{ENV['CHORUS_HOME']}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.before(:all) do
    self.class.set_fixture_class :events => Events::Base
    self.class.fixtures :all
  end

  config.before(:each) do
    Rails.logger.info "Started test: #{example.full_description}"
  end

  config.before(:each) do
    stub(License.instance).[](:vendor) { License::OPEN_CHORUS }
    ActionMailer::Base.deliveries.clear
  end

  config.after(:each) do
    Rails.logger.info "Finished test: #{example.full_description}"
  end

  config.before do
    Sunspot.session = SunspotMatchers::SunspotSessionSpy.new(Sunspot.session)
  end

  config.after do
    QC::Conn.disconnect
    Sunspot.session = Sunspot.session.original_session if Sunspot.session.is_a? SunspotMatchers::SunspotSessionSpy
    set_current_user nil
  end

  config.include AuthHelper, :type => :controller
  config.include CurrentUserHelpers
  config.include FileHelper
  config.include Paperclip::Shoulda::Matchers
  config.include GpdbTestHelpers
  config.include GreenplumIntegration, :greenplum_integration => true
  config.include SunspotMatchers
  config.include SolrHelpers
  # config.extend ApiDocHelper, :api_doc_dsl => :endpoint
end
