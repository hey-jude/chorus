require 'spec_helper'
require 'rake'

describe 'db' do
  before { Chorus::Application.load_tasks }

  context "migrate_permissions" do
    it "should not run again if it has already been run once" do
      ENV['force'] = 'false'

      Rake::Task["db:migrate_permissions"].execute
      expect{Rake::Task["db:migrate_permissions"].execute}.to raise_exception(SystemExit)
    end
  end

end