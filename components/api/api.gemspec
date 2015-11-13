$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "api"
  s.version     = Api::VERSION
  s.platform    = 'jruby'
  s.authors     = ["Prakash Teli", "Kevin Trowbridge"]
  s.email       = ["prakash@alpinenow.com", "kevin@alpinenow.com"]
  s.homepage    = "http://alpinenow.com"
  s.summary     = "Chorus API component."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency 'core'

  s.add_dependency 'actionpack', '4.1.10'
  s.add_dependency 'actionview', '4.1.10'
  s.add_dependency 'activeresource', '4.0.0'
  s.add_dependency 'compass-rails', '2.0.4'

  # generate JSON data output using Rails View
  s.add_dependency 'jbuilder', '2.3.0'

  # s.add_dependency 'newrelic_rpm', '3.12.0.288'
  s.add_dependency 'nokogiri', '1.6.6.2'
  s.add_dependency 'sass-rails', '5.0.1'
  s.add_dependency 'sunspot_rails', '2.1.0'
  s.add_dependency 'will_paginate', '3.0.4'

  # Need to install 0.99.4 version of mustache gem. Latest version is not compatible with Jruby 1.7
  s.add_dependency 'mustache', '0.99.4'

  s.add_development_dependency 'rspec_api_documentation'

  s.add_development_dependency 'rspec-rails', '2.99.0'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'fixture_builder'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'shoulda-matchers'

  s.add_development_dependency 'faker'

  # Ruby test helper for injecting fake responses to web requests
  s.add_development_dependency 'fakeweb'

  s.add_development_dependency 'hashie'

  # KT: Group all Solr related together ..
  s.add_development_dependency 'rsolr', '1.0.10' # block deprecation notices, delete this when upgrading Sunspot to 2.2.0
  s.add_development_dependency 'sunspot_matchers', '2.1.0'
  s.add_development_dependency 'sunspot_solr', '2.1.0'

  s.add_development_dependency 'vcr', '~> 2.3.0'

  # The Bullet gem is designed to help you increase your application's performance by reducing the number of queries it makes.
  # But -- it is disabled.
  s.add_development_dependency 'bullet'

  s.add_development_dependency 'database_cleaner'

  # RR (Double Ruby) is a test double framework that features a rich selection of double techniques and a terse syntax
  s.add_development_dependency 'rr'

  # a Pivotal gem: "Find licenses for your project's dependencies."
  s.add_development_dependency 'license_finder'

  # A Fake Filesystem, used in install & model tests
  s.add_development_dependency 'fakefs', '0.4.2'
end
