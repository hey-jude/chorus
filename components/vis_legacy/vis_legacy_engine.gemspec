$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "vis_legacy/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "vis_legacy"
  s.version     = VisLegacy::VERSION
  s.authors     = ["Kevin Trowbridge"]
  s.email       = ["kevin@alpinenow.com"]
  s.homepage    = ""
  s.summary     = "Legacy visualization system for Chorus."
  # s.description = "Description of VisEngine."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]
end
