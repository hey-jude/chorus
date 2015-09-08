require 'spec_helper'
require 'rake'

describe 'db' do
  before { Chorus::Application.load_tasks }

  context "migrate_permissions" do

    it "should not run again if it has already been run once" do
      ENV['force'] = 'false'

      original_stdout = $stdout
      $stdout = File.open(File::NULL, "w")

      begin
        Rake::Task["db:migrate_permissions"].execute
      rescue SystemExit
        # Sometimes the task has already been run as part of the fixture building process,
        # so we try to execute it twice to be sure we have the same state
      end
      expect{Rake::Task["db:migrate_permissions"].execute}.to raise_exception(SystemExit)

      $stdout = original_stdout
    end
  end

end