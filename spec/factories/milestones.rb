require 'factory_girl'

FactoryGirl.define do

  factory :milestone do
    sequence(:name) { |n| "Milestone #{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    state { ["planned", "achieved"].sample }
    target_date { Date.today + rand(100) }
    workspace
  end

end