require 'fileutils'
require 'zip/zip'

module LogArchiver

  ARCHIVE_DIRECTORY = "#{Rails.root}/tmp/log_archiver/archives"
  STAGING_DIRECTORY = "#{Rails.root}/tmp/log_archiver/staging"

  def create_archive
    Dir.chdir(Rails.root)

    logfile_paths = truncate_logs
    zipfile_path = generate_zipfile(logfile_paths)
    cleanup

    zipfile_path
  end

  def truncate_logs
    Dir.chdir("#{Rails.root}/log")

    num_lines = ChorusConfig.instance['logging.archiver_truncate_number_of_lines']

    FileUtils::mkdir_p STAGING_DIRECTORY
    log_files = Array.new
    Dir.glob('*.log').each do |log_file|
      system("tail -n #{num_lines} \"#{log_file}\" > \"#{STAGING_DIRECTORY}/#{log_file}\"")
      log_files << log_file
    end

    Dir.chdir(Rails.root)

    log_files
  end

  def generate_zipfile(logfile_paths)
    # alpine_logs_20150720150924.zip
    zipfile_name =  "#{ARCHIVE_DIRECTORY}/alpine_logs_#{Time.now.to_formatted_s(:number)}.zip"

    Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
      logfile_paths.each do |log_file|
        zipfile.add(log_file, "#{STAGING_DIRECTORY}/#{log_file}")
      end
    end

    zipfile_name
  end

  def cleanup
    `rm #{STAGING_DIRECTORY}/*`
  end
end