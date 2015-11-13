require 'spec_helper'

resource "Notes" do
  let(:user) { users(:owner) }
  let(:note) { events(:note_on_hdfs_file) }
  let(:hdfs_file) { HdfsEntry.files.first }
  let(:attachment) { attachments(:sql) }

  before do
    log_in user
  end

  post "/notes/:note_id/attachments" do
   parameter :note_id, "Note id"
   parameter :svg_data, "SVG File contents"

   required_parameters :note_id, :svg_data

   let(:note_id) { note.id }
   let(:svg_data) { test_file("SVG-logo.svg").read }

   example_request "Attach a visualization to a note" do
     status.should == 200
   end
  end

end
