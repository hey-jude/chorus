$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "web_style/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "web_style"
  s.version     = WebStyle::VERSION
  s.authors     = ["Kevin Trowbridge"]
  s.email       = ["kevin@alpinenow.com"]
  s.summary     = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  # s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.10"

  s.add_dependency 'sass-rails', '>= 3.2'
end
