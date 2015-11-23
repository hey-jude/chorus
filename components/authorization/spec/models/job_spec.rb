require 'spec_helper'

describe Job do
  let(:ready_job) { FactoryGirl.create(:job, :status => Job::ENQUEUED, :next_run => 1.second.ago) }

  it_behaves_like "a permissioned model" do
    let!(:model) { ready_job }
  end
end
