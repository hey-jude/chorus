require 'factory_girl'

FactoryGirl.define do

  factory :membership do
    user
    workspace
  end

end