source 'https://rubygems.org'

path 'components' do
  gem 'api'
  gem 'authorization'
  gem 'core'
  gem 'frontend'
  gem 'vis_legacy'
end

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
  gem 'rr'
  gem 'rspec-rails', '2.99.0'
  gem 'shoulda-matchers'
  gem 'simplecov', :require => false
  gem 'sunspot_matchers'
  gem 'timecop'
end

group :packaging do
  gem 'jetpack', :github => 'Chorus/jetpack', :branch => '6c9253195b+chorus', :require => false
end