$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "frontend/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "frontend"
  s.version = Frontend::VERSION
  s.platform = 'jruby'
  s.authors = ["Prakash Teli", "Kevin Trowbridge"]
  s.email = ["prakash@alpinenow.com", "kevin@alpinenow.com"]
  s.homepage = "http://alpinenow.com"
  s.summary = "Chorus 'Frontend Backbone' component."
  s.license = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'api'
  s.add_dependency 'vis_legacy'

  s.add_dependency 'actionpack', '4.1.10'
  s.add_dependency 'actionview', '4.1.10'

  # JS assets for "Client-side growl-like notifications with actions and auto-retry"
  s.add_dependency 'messengerjs-rails', '1.4.1'

  # Has to do with codemirror clientside rich text editor
  s.add_dependency 'codemirror-rails', '5.3'

  # Need to install 0.99.4 version of mustache gem. Latest version is not compatible with Jruby 1.7
  s.add_dependency 'mustache', '0.99.4'

  # assets
  s.add_dependency 'sass-rails', '5.0.1'
  s.add_dependency 'compass-rails', '2.0.4'
  s.add_dependency 'handlebars_assets', '0.14.1'
  s.add_dependency 'therubyrhino', '2.0.4'
  s.add_dependency 'uglifier', '2.7.1'
  s.add_dependency 'yui-compressor', '0.12.0'
  s.add_dependency 'jquery-rails', '2.1.4'

  s.add_development_dependency 'quiet_assets'

  # KT TODO: run jasmine specs and figure out development dependencies
  s.add_dependency 'mizuno'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rr'
  s.add_development_dependency 'fuubar'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'rspec-rails', '2.99.0'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'bullet'
end
