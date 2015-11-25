$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "admin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "admin"
  s.version     = Admin::VERSION
  s.authors     = ["Kevin Trowbridge"]
  s.email       = ["kevin@alpinenow.com"]
  s.summary     = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  # s.test_files = Dir["test/**/*"]

  s.add_dependency "core"
  s.add_dependency "authorization"
  s.add_dependency "web_style"

  # s.add_dependency "rails", "~> 4.1.10"

  s.add_dependency 'jquery-rails'
  s.add_dependency 'bootstrap-sass', '~> 3.3.5'
  s.add_dependency 'sass-rails', '>= 3.2'
  s.add_dependency 'breadcrumbs_on_rails'
end
