$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "authorization/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "authorization"
  s.version     = Authorization::VERSION
  s.authors     = ["Kevin Trowbridge"]
  s.email       = ["kevin@alpinenow.com"]
  s.summary     = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'core'
  s.add_dependency 'bitmask_attributes'
end
