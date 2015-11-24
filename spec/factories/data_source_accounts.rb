require 'factory_girl'

FactoryGirl.define do

  factory :data_source_account do
    sequence(:db_username) { |n| "username#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    db_password "secret"
    owner
    association :data_source, :factory => :gpdb_data_source
  end
end