source 'https://rubygems.org'

gem 'admin', :path => 'components/admin'
gem 'api', :path => 'components/api'
gem 'authorization', :path => 'components/authorization_simpler'
gem 'core', :path => 'components/core'
gem 'frontend', :path => 'components/frontend'
gem 'vis_legacy', :path => 'components/vis_legacy'
gem 'web_style', :path => 'components/web_style'

gem 'hadoopconf_gem', :github => 'Chorus/chorus-hadoop-conf', :ref => 'ce0d34dde0f5f4dd372af6406fafd9c5b2baac5f'
gem 'queue_classic', :github => 'Chorus/queue_classic'
gem 'chorusgnip', :github => 'Chorus/gnip'

# KT: Having these gems here is useful for debugging via RubyMine.
group :development, :test do
  gem 'backbone_fixtures_rails', :github => 'charleshansen/backbone_fixtures_rails'
  gem 'bullet'
  gem 'factory_girl'
  gem 'fixture_builder'
  gem 'hashie'
  gem 'jasmine', :github => 'pivotal/jasmine-gem'
  gem 'jasmine-core', :github => 'pivotal/jasmine'
  gem 'rr', '1.1.2'
  gem 'rspec-rails', '2.99.0'
  gem 'shoulda-matchers', '2.8.0'
  gem 'simplecov', '0.10.0', :require => false
  gem 'sunspot_matchers', '2.1.0.0'
  gem 'timecop', '0.8.0'
end

group :packaging do
  gem 'jetpack', :github => 'Chorus/jetpack', :branch => '6c9253195b+chorus', :require => false
end