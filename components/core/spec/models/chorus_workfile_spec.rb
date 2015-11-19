require 'spec_helper'

describe ChorusWorkfile do
  describe 'validations' do
    context 'file name with valid characters' do
      it 'is valid' do
        workfile = FactoryGirl.build(:chorus_workfile, :file_name => 'work_(-file).sql')
        workfile.should be_valid
      end
    end

    context 'file name with question mark' do
      it 'is not valid' do
        workfile = FactoryGirl.build(:chorus_workfile, :file_name => 'workfile?.sql')
        workfile.should have_error_on(:file_name)
      end
    end

    context 'file name with a slash' do
      it 'is not valid' do
        workfile = FactoryGirl.build(:chorus_workfile, :file_name => 'a/file.sql')
        workfile.should have_error_on(:file_name)
      end
    end
  end

  describe 'creating with file data' do
    let(:user) { users(:admin) }
    let(:workspace) { workspaces(:public_with_no_collaborators) }

    shared_examples 'file upload' do
      it 'creates a workfile in the database' do
        workfile.should be_valid
        workfile.should be_persisted
      end

      it 'creates a workfile version in the database' do
        workfile.versions.should have(1).version

        version = workfile.versions.first
        version.should be_valid
        version.should be_persisted
      end

      it 'sets the attributes of the workfile' do
        workfile.owner.should == user
        workfile.file_name.should == 'workfile.sql'
        workfile.workspace.should == workspace
      end

      it 'has a valid latest version' do
        workfile.latest_workfile_version.should_not be_nil
      end

      it 'sets the modifier of the first, recently created version' do
        workfile.versions.first.modifier.should == user
      end

      it 'sets the attributes of the workfile version' do
        version = workfile.versions.first

        version.contents.should be_present
        version.version_num.should == 1
      end

      it 'does not set a commit message' do
        workfile.versions.first.commit_message.should be_nil
      end
    end

    context 'with versions' do
      let(:execution_schema) { nil }
      let(:contents) { test_file('workfile.sql') }

      let(:attributes) do
        {
          :description => 'Nice workfile, good workfile',
          :versions_attributes => [{
                                     :contents => contents
                                   }],
          :execution_schema => ({:id => execution_schema.id} if execution_schema),
          :workspace => workspace,
          :owner => user
        }
      end
      let(:workfile) { ChorusWorkfile.build_for(attributes).tap { |w| w.save! } }

      before do
        workspace.sandbox = schemas(:default)
        workspace.save!
      end

      it_behaves_like 'file upload'

      it 'sets the content of the workfile' do
        workfile.versions.first.contents.size.should > 0
        workfile.content_type.should == 'sql'
      end

      it 'sets the right description on the workfile' do
        workfile.description.should == attributes[:description]
      end

      it 'sets the execution_schema to the workspace sandbox' do
        workspace.sandbox.should be_present
        workfile.execution_schema.should == workspace.sandbox
      end

      context 'when the workfile is not a sql workfile' do
        let(:contents) { test_file('some.txt') }

        it 'does not set the execution_schema' do
          workfile.execution_schema.should be_nil
        end
      end
    end

    context 'without a version' do
      let(:workfile) { ChorusWorkfile.build_for(:file_name => 'workfile.sql', :workspace => workspace, :owner => user).tap { |w| w.save! } }

      it_behaves_like 'file upload'

      it 'sets the file as blank' do
        workfile.versions.first.contents.size.should == 0
        workfile.versions.first.file_name.should == 'workfile.sql'
      end
    end

    context 'with an image extension on a non-image file' do
      let(:attributes) do
        {
          :versions_attributes => [
            {
              :contents => test_file('not_an_image.jpg')
            }
          ],
          :workspace => workspace,
          :owner => user
        }
      end

      it 'is invalid' do
        workfile = ChorusWorkfile.build_for(attributes)
        workfile.save.should be_false
        workfile.should have_error_on(:versions)
        workfile.versions.first.should have_error_on(:contents)
      end
    end
  end

  describe '#build_new_version' do

    let(:user) { users(:owner) }
    let(:workspace) { FactoryGirl.build(:workspace, :owner => user) }
    let(:workfile) { FactoryGirl.build(:chorus_workfile, :workspace => workspace, :file_name => 'workfile.sql') }

    context 'when there is a previous version' do
      let(:workfile_version) { FactoryGirl.build(:workfile_version, :workfile => workfile) }

      before do
        workfile_version.contents = test_file('workfile.sql')
        workfile_version.save
      end

      it 'build a new version with version number increased by 1 ' do
        workfile_version = workfile.build_new_version(user, test_file('workfile.sql'), 'commit Message')
        workfile_version.version_num.should == 2
        workfile_version.commit_message.should == 'commit Message'
        workfile_version.should_not be_persisted
      end
    end

    context 'creating the first version' do
      it 'build a version with version number as 1' do
        workfile_version = workfile.build_new_version(user, test_file('workfile.sql'), 'commit Message')
        workfile_version.version_num.should == 1
        workfile_version.commit_message.should == 'commit Message'
        workfile_version.should_not be_persisted
      end
    end
  end

  describe 'remove_draft' do
    let(:user) { users(:owner) }
    let(:workfile) { workfiles(:public) }

    before do
      draft = workfile.drafts.build
      draft.owner_id = user.id
      draft.save
    end

    it 'deletes a draft belonging to the specified user' do
      expect { workfile.remove_draft(user) }.to change(WorkfileDraft, :count).by(-1)
    end
  end

  describe '#create_new_version' do
    let(:user) { users(:owner) }
    let(:workfile) { workfiles(:public) }

    context 'when :content is a string' do
      it 'changes the file content' do
        workfile.create_new_version(user, {:content => 'New content', :commit_message => 'A new version'})

        new_version = workfile.latest_workfile_version
        File.read(new_version.contents.path).should == 'New content'
        new_version.commit_message.should == 'A new version'
        new_version.version_num.should == 2
      end
    end

    context 'when :content is an uploaded file' do
      let(:file) { test_file('some.txt', 'text/plain') }

      it 'changes the file content' do
        workfile.create_new_version(user, {:content => file, :commit_message => 'A new version'})

        new_version = workfile.latest_workfile_version
        File.read(new_version.contents.path).should == File.read(file.path)
        new_version.commit_message.should == 'A new version'
        new_version.version_num.should == 2
      end
    end

    it 'deletes any saved workfile drafts for this workfile and user' do
      workfile_drafts(:draft_default).update_attribute(:workfile_id, workfile.id)
      draft_count(workfile, user).should == 1
      workfile.create_new_version(user, {})
      draft_count(workfile, user).should == 0
    end
  end

  describe '#create_event_for_upgrade' do
    let(:workfile) { workfiles(:public) }
    let(:user) { users(:owner) }

    it 'adds a workfile upgraded version event' do
      workfile.build_new_version(user, test_file('workfile.sql'), 'commit Message').save!
      workfile.create_event_for_upgrade(user)

      event = Events::WorkfileUpgradedVersion.by(user).last
      event.workfile.should == workfile
      event.workspace.to_param.should == workfile.workspace.id.to_s
      event.additional_data["version_num"].should == workfile.latest_workfile_version.version_num
      event.additional_data["commit_message"].should == 'commit Message'
    end
  end

  describe '#has_draft' do
    let(:workspace) { workspaces(:public) }
    let(:user) { workspace.owner }
    let!(:workfile1) { FactoryGirl.create(:chorus_workfile, :file_name => 'some.txt', :workspace => workspace) }
    let!(:workfile2) { FactoryGirl.create(:chorus_workfile, :file_name => 'workfile.sql', :workspace => workspace) }
    let!(:draft) { FactoryGirl.create(:workfile_draft, :workfile_id => workfile1.id, :owner_id => user.id) }

    # these are failing
    it 'has_draft return true for workfile1' do
      workfile1.has_draft(user).should == true
    end

    it 'has_draft return false for workfile2' do
      workfile2.has_draft(user).should == false
    end
  end

  describe 'associations' do
    it 'belongs to an execution_schema' do
      workfile = workfiles(:private)
      workfile.execution_schema.should be_a GpdbSchema
    end
  end

  def draft_count(workfile, user)
    workfile.drafts.where(:owner_id => user.id).count
  end
end
