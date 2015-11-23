require 'factory_girl'

FactoryGirl.define do

  factory :upload do
    user
    contents { Rack::Test::UploadedFile.new(File.expand_path('spec/fixtures/files/test.csv', ENV['CHORUS_HOME']), 'text/csv') }
  end

end

