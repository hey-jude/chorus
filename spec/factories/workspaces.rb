require 'factory_girl'

FactoryGirl.define do

  factory :workspace do
    sequence(:name) { |n| "workspace#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    owner
    project_status 'on_track'
    is_project false

    public true

    after(:create) do |workspace|
      FactoryGirl.create(:membership, :workspace => workspace, :user => workspace.owner)
    end

    factory :workspace_with_sandbox do
      association :sandbox, factory: :gpdb_schema
    end

    factory :project do
      project_status_reason { Faker::Company.catch_phrase }
      is_project true

      after(:create) do |project|
        Events::ProjectStatusChanged.by(project.owner).add(:workspace => project)
        5.times { project.milestones.create(FactoryGirl.attributes_for(:milestone)) }
      end
    end
  end

end