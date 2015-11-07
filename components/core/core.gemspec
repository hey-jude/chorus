$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "core"
  s.version = Core::VERSION
  s.platform = 'jruby'
  s.authors = ["Prakash Teli", "Kevin Trowbridge"]
  s.email = ["prakash@alpinenow.com", "kevin@alpinenow.com"]
  s.homepage = "http://alpinenow.com"
  s.summary = "Chorus database core component."
  s.license = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "spec/factories/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency 'activerecord', '4.1.10'
  s.add_dependency 'actionmailer', '4.1.10'

  # KT TODO: "Rails 4.0 has removed attr_accessible and attr_protected feature in favor of Strong Parameters. You can use the
  # Protected Attributes gem for a smooth upgrade path."
  # Due to config/initializers/additional_data.rb it's not trivial to delete all the attr_accessible pieces from the
  # models.  This gem should be removed via refactoring after the Rails 4 upgrades are merged into master.
  s.add_dependency 'protected_attributes'

  s.add_dependency 'newrelic_rpm'
  s.add_dependency 'paperclip', '4.2.0'
  s.add_dependency 'sunspot_rails', '2.1.0'
  s.add_dependency 'will_paginate', '3.0.4'

  # A scheduler process to replace cron
  s.add_dependency 'clockwork'

  # Has to do with license functionality
  s.add_dependency 'honor_codes', '~> 0.1.0'

  # some sort of logging plugin, but we're going to replace with Prakash's Java logger
  s.add_dependency 'logger-syslog'

  s.add_dependency 'net-ldap', '0.11'

  # CSS styled emails without the hassle
  s.add_dependency 'premailer-rails'

  # Gem that allows you to call view renders from anywhere (model, lib, rake, etc.)
  s.add_dependency 'render_anywhere'

  # simple, flexible, and powerful SQL database access toolkit for Ruby
  s.add_dependency 'sequel', '~> 4.0'

  # Look at models/data_source_account
  s.add_dependency 'attr_encrypted'

  # jRuby
  s.add_dependency 'jruby-openssl'
  s.add_dependency 'activerecord-jdbcpostgresql-adapter'

  # The Bullet gem is designed to help you increase your application's performance by reducing the number of queries it makes.
  # But -- it is disabled.
  s.add_development_dependency 'bullet'

  # Used to test svg_to_png
  s.add_development_dependency 'chunky_png'

  # add-on to popular test frameworks that allows you to generate XML reports
  s.add_development_dependency 'ci_reporter'

  s.add_development_dependency 'factory_girl'

  # A Fake Filesystem, used in install & model tests
  s.add_development_dependency 'fakefs'

  s.add_development_dependency 'faker'

  # Ruby test helper for injecting fake responses to web requests
  s.add_development_dependency 'fakeweb'

  s.add_development_dependency 'fixture_builder'
  s.add_development_dependency 'foreman'

  # instafailing RSpec progress bar formatter
  s.add_development_dependency 'fuubar'

  #  LDAP server instance for use in testing
  s.add_development_dependency 'ladle'

  # a Pivotal gem: "Find licenses for your project's dependencies."
  s.add_development_dependency 'license_finder'

  s.add_development_dependency 'minitest'

  # RR (Double Ruby) is a test double framework that features a rich selection of double techniques and a terse syntax
  s.add_development_dependency 'rr'

  s.add_development_dependency 'rsolr', '1.0.10'
  s.add_development_dependency 'rspec-rails', '2.99.0'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'sunspot_matchers', '2.1.0'
  s.add_development_dependency 'sunspot_solr', '2.1.0'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'vcr', '~> 2.3.0'
end
