$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'admin/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'admin'
  s.version     = Admin::VERSION
  s.authors     = ['Prakash Teli, Atul Veer']
  s.email       = ['prakash@alpinenow.com, atulveer@alpinenow.com']
  s.homepage    = ''
  s.summary     = 'Chorus Admin Component'
  s.description = 'Chorus Admin Component'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '4.1.10'
  s.add_dependency 'jquery-rails', '2.1.4'
  s.add_dependency 'gretel', '3.0.8'
  s.add_dependency 'jquery-ui-rails'

end
