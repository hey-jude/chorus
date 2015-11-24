require 'factory_girl'

FactoryGirl.define do

  factory :system_status do
    expired false
    user_count_exceeded false
  end

end

