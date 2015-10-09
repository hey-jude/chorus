class LogArchiversController < ApplicationController
  include LogArchiver

  def show
    archive_path = create_archive

    send_file(File.join(archive_path),
              :type => "application/zip",
              :file_name => archive_path,
              :disposition => 'attachment',
              :x_sendfile => true)
  end
end
