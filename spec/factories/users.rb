require 'factory_girl'

FactoryGirl.define do
  factory :user, :aliases => [:owner, :modifier, :actor] do
    sequence(:username) { |n| "user#{n}" }
    password 'password'
    first_name 'Chorus'
    last_name 'User'
    title 'Chief Data Scientist'
    dept 'Corporation Corp., Inc.'
    notes 'One of our top performers'
    email 'chorususer@alpinenow.com'
    user_type License::USERS_ANALYTICS_DEVELOPER
  end

  factory :admin, :parent => :user do
    sequence(:first_name) { |n| "Admin_#{n}" }
    sequence(:last_name) { |n| "User_#{n}" }
    admin true
  end
end