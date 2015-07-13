class DataDownloadsController < ApplicationController
  include FileDownloadHelper
  include ChorusLogger

  def download_data
    send_data params[:content], :type => params[:mime_type], :filename => filename_for_download(params[:filename])
  end

  def download_logs
     log_file = generate_log_file
     logger.info "file name :" + log_file.to_s
     send_file(File.join('/public',log_file), :type => "application/zip", :file_name => filename_for_download(log_file))
  end
end
