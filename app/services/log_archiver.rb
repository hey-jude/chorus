require 'fileutils'
#require 'zip/zip'
require 'zip_file_generator'


module LogArchiver

  ARCHIVE_DIRECTORY = "#{Rails.root}/tmp/log_archiver/archives"
  STAGING_DIRECTORY = "#{Rails.root}/tmp/log_archiver/staging"

  CHORUS_LOGS = {log_name: "Chorus",
                 staging_dir: "#{Rails.root}/tmp/log_archiver/staging/chorus_logs",
                 log_path: "#{Rails.root}/log"}

  ALPINE_LOGS = {log_name: "Alpine",
                 staging_dir: "#{Rails.root}/tmp/log_archiver/staging/alpine_logs",
                 log_path: "#{Dir.home}"}

  ALPINE_INSTALL_LOGS = {log_name: "Alpine Install",
                         staging_dir: "#{Rails.root}/tmp/log_archiver/staging/alpine_install_logs",
                         log_path: "/tmp/"}

  POSTGRES_LOGS = {log_name: "Postgres",
                   staging_dir: "#{Rails.root}/tmp/log_archiver/staging/postgres_logs",
                   log_path: "#{(`echo $CHORUS_HOME`).to_s.strip}/shared/db"}

  TOMCAT_LOGS = {log_name: "Tomcat",
                 staging_dir: "#{Rails.root}/tmp/log_archiver/staging/tomcat_logs",
                 log_path: "#{(`echo $CHORUS_HOME`).to_s.strip}/alpine-current/apache-tomcat-7.0.41/logs"}

  LOGS = Array.new
  LOGS << CHORUS_LOGS
  LOGS << ALPINE_LOGS
  LOGS << ALPINE_INSTALL_LOGS
  LOGS << POSTGRES_LOGS
  LOGS << TOMCAT_LOGS


  def create_archive
    Dir.chdir(Rails.root)

     truncate_logs
    zipfile_path = generate_zipfile
    cleanup

    zipfile_path
  end

  def truncate_logs
    LOGS.each do |log|
       Dir.chdir(log[:log_path])
       num_lines = ChorusConfig.instance['logging.archiver_truncate_number_of_lines']
       FileUtils::mkdir_p log[:staging_dir]
       Dir.glob('*.log').each do |log_file|
         system("tail -n #{num_lines} \"#{log_file}\" > \"#{log[:staging_dir]}/#{log_file}\"")
       end
    end
     Dir.chdir(Rails.root)
  end

  def generate_zipfile()
    # alpine_logs_20150720150924.zip
    zipfile_name =  "#{ARCHIVE_DIRECTORY}/alpine_logs_#{Time.now.to_formatted_s(:number)}.zip"
    zip_file = ZipFileGenerator.new(STAGING_DIRECTORY, zipfile_name)
    zip_file.write()

    zipfile_name
  end

  def cleanup
    `rm -rf #{STAGING_DIRECTORY}/*`
  end
end
