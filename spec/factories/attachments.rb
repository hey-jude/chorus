require 'factory_girl'

FactoryGirl.define do
  factory :attachments do
    contents { fixture_file_upload(Pathname.new(ENV['RAILS_ROOT']).join('spec', 'fixtures', 'files', 'workfile.sql'), 'text/plain') }
  end
end