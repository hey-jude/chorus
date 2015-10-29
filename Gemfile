source 'https://rubygems.org'

path 'components' do
  gem 'core'
  gem 'api'
  gem 'frontend'
  gem 'vis_legacy'
end

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
