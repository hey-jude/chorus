require 'spec_helper'

describe Api::HdfsDataSourcePresenter, :type => :view do
  let(:hdfs_data_source) { hdfs_data_sources(:hadoop) }
  let(:options) { {} }
  let(:user) { hdfs_data_source.owner }

  before do
    set_current_user(user)
  end

  describe "#to_hash" do

    context "when HdfsDataSource is_hdfs_hive is false" do
      let(:presenter) { Api::HdfsDataSourcePresenter.new(hdfs_data_source, view, options) }
      let(:hash) { presenter.to_hash }

      it "should have the correct keys" do
        hash.should have_key(:name)
        hash.should have_key(:host)
        hash.should have_key(:port)
        hash.should have_key(:id)
        hash.should have_key(:is_deleted)
        hash.should have_key(:owner)
        hash.should have_key(:description)
        hash.should have_key(:version)
        hash.should have_key(:username)
        hash.should have_key(:group_list)
        hash.should have_key(:online)
        hash.should have_key(:tags)
        hash.should have_key(:supports_work_flows)
        hash.should have_key(:job_tracker_host)
        hash.should have_key(:job_tracker_port)
        hash.should have_key(:hdfs_version)
        hash.should have_key(:high_availability)
        hash.should have_key(:connection_parameters)
        hash[:entity_type].should == 'hdfs_data_source'
      end

      it "presents an empty array when there are no additional connection parameters" do
        hash[:connection_parameters].should == []
      end

      it "should use ownerPresenter Hash method for owner" do
        owner = hash[:owner]
        owner.to_hash.should == (Api::UserPresenter.new(user, view).presentation_hash)
      end

      it_behaves_like "activity stream data source presenter"
      it_behaves_like :succinct_data_source_presenter

      context "in succinct mode" do
        let(:options) { {:succinct => true} }

        it "should have the correct keys" do
          hash.should have_key(:supports_work_flows)
          hash.should have_key(:hdfs_version)
        end
      end
    end

    context "when HdfsDataSource is_hdfs_hive is true" do
      let(:hdfs_hive_data_source) { hdfs_data_sources(:hdfs_hive) }
      let(:hive_presenter) { Api::HdfsDataSourcePresenter.new(hdfs_hive_data_source, view, options) }
      let(:hash) { hive_presenter.to_hash }

      it "should have the correct keys" do

        hash.should have_key(:is_hdfs_hive)
        hash[:is_hdfs_hive].should be_true

        hash.should have_key(:hive_metastore_location)
        hash[:hive_metastore_location].should_not be_empty

        hash.should have_key(:connection_parameters)
        hash[:connection_parameters].should_not be_empty
        hash[:connection_parameters].select { |a| a['key'] == 'is_hive' }.should be_true
        hash[:connection_parameters].select { |a| a['key'] == 'hive.metastore.uris' }.should be_present
      end
    end

  end
end