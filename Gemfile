source 'https://rubygems.org'

path 'components', :platform => 'jruby' do
  gem 'core'
  gem 'api'
  gem 'frontend'
  gem 'vis_legacy'
end

gem 'hadoopconf_gem', :github => 'Chorus/chorus-hadoop-conf', :ref => 'ce0d34dde0f5f4dd372af6406fafd9c5b2baac5f'
gem 'queue_classic', :github => 'Chorus/queue_classic'
gem 'chorusgnip', :github => 'Chorus/gnip'

group :development do
  gem 'bullet'
end

group :development, :test, :integration, :packaging, :ci_jasmine, :ci_legacy, :ci_next do
  gem 'simplecov', :require => false
  gem 'backbone_fixtures_rails', :github => 'charleshansen/backbone_fixtures_rails'
  gem 'jetpack', :github => 'Chorus/jetpack', :branch => '6c9253195b+chorus', :require => false
end
