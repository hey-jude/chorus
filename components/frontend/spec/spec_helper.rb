if ENV["COVERAGE"] == "true"
  require 'simplecov'

  SimpleCov.start do
    add_filter "/spec/" # Ignore coverage for _spec.rb files because they are always 100%
  end
end

require 'rubygems'
ENV["RAILS_ENV"] ||= 'test'
ENV["LOG_LEVEL"] = '3'

CBRA_ROOT = Pathname.new(File.expand_path("../.."))
require File.expand_path("../dummy/config/environment", __FILE__)

require 'rspec/rails'
require 'rspec/autorun'
require 'shoulda-matchers'
require 'rr'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Frontend::Engine.root.join("spec/support/**/*.rb")].each { |f| require f unless f.match /fixture_builder/ }

SPEC_PASSWORD = 'password'

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{CBRA_ROOT}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.before(:all) do
    self.class.fixtures :all
  end

  config.before(:each) do
    Rails.logger.info "Started test: #{example.full_description}"
  end

  config.after(:each) do
    Rails.logger.info "Finished test: #{example.full_description}"
  end

  config.after do
    set_current_user nil
  end

  config.include CurrentUserHelpers
  config.include AuthHelper, :type => :controller
end
