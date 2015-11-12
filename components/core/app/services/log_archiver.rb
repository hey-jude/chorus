require 'fileutils'
require 'zip_file_generator'

module LogArchiver

  ARCHIVE_DIR = "#{Rails.root}/tmp/log_archiver"
  ASSEMBLE_ZIP_DIR = "#{ARCHIVE_DIR}/tmp"

  def create_archive
    `mkdir -p #{ASSEMBLE_ZIP_DIR}`

    @log_archiver_logfile = File.new("#{ASSEMBLE_ZIP_DIR}/log_archiver.log", "w+")
    start_time = Time.now
    log "Log archiver started at #{start_time.to_formatted_s(:long)}"
    log "Truncating logs into #{ASSEMBLE_ZIP_DIR} ..."

    # KT: chorus_control.sh modifies $CHORUS_HOME for the webserver process -- appending './current'
    @chorus_home = "#{(`echo $CHORUS_HOME`).to_s.strip}/../.."

    add_logs
    add_config_files
    add_licences
    add_properties
    add_hdfs_data_sources

    log "Zipping, after: #{Time.now - start_time}."
    @log_archiver_logfile.close()

    # alpine_logs_20150720150924.zip
    zip_file_path = zip

    zip_file_path
  end

  private

  def log_cmd(cmd)
    log cmd
    log `#{cmd}`
  end

  def log(msg)
    unless msg.blank?
      logger.debug msg
      @log_archiver_logfile.write("#{msg}\n")
      @log_archiver_logfile.flush
    end
  end

  # KT: from Nate ... see: https://alpine.atlassian.net/browse/DEV-11637
  # Alpine.log > chorus user's home directory
  # AlpineAgent_x.log > chorus user's home directory
  # install.log > /tmp/install.log
  # pgadmin.log (called server.log) > $CHORUS_HOME/shared/db
  # tomcat logs > $CHORUS_HOME/alpine-current/apache-tomcat-7.0.41/logs
  def log_locations

    alpine = {path: "#{Dir.home}",
              archive_path: "#{ASSEMBLE_ZIP_DIR}/alpine_logs"}

    alpine_install = {path: "/tmp/install.log",
                      archive_path: "#{ASSEMBLE_ZIP_DIR}/alpine_install_logs"}

    postgres = {path: "#{@chorus_home}/shared/db/server.log",
                archive_path: "#{ASSEMBLE_ZIP_DIR}/postgres_logs"}

    chorus = {path: "#{Rails.root}/log",
              archive_path: "#{ASSEMBLE_ZIP_DIR}/chorus_logs"}

    tomcat = {path: max_version_tomcat_path,
              archive_path: "#{ASSEMBLE_ZIP_DIR}/tomcat_logs"}

    [chorus, alpine, alpine_install, postgres, tomcat]
  end

  def max_version_tomcat_path
    dirs = Dir.glob(tomcat_path('*'))
    versions = dirs.collect { |dir|
      dir[/apache-tomcat-([\d\.]+)/, 1] # from "apache-tomcat-1.2.3.4", return "1.2.3.4"
    }

    # http://stackoverflow.com/questions/2051229/how-to-compare-versions-in-ruby
    max_version = versions.map { |v| Gem::Version.new v }.max.to_s

    tomcat_path(max_version)
  end

  def tomcat_path(version)
    "#{@chorus_home}/alpine-current/apache-tomcat-#{version}/logs"
  end

  def add_logs

    log_locations.each do |log|
      if File.exists?(log[:path])

        log_cmd "mkdir -p #{log[:archive_path]}"

        if File.directory?(log[:path])
          Dir.glob("#{log[:path]}/*.log").each do |file|

            basename = File.basename(file)

            # KT: Don't vacuum up tons of log-rotated files. Everett helped me find the long-running server 10.0.0.233
            # which has good examples.
            exclusion_regexes = [
              /.*\d{4}_\d{2}_\d{2}.*/ # jetty_stderr_2015_06_24.log, jetty_request_2015_07_20.log
            ]

            if exclusion_regexes.any? { |regex| regex.match(basename) }
              log "Skipping #{file} because it matches an exclusion_regex."
            else
              truncate_file(file, "#{log[:archive_path]}/#{File.basename(file)}")
            end
          end
        else # not a directory
          truncate_file(log[:path], "#{log[:archive_path]}/#{File.basename(log[:path])}")
        end
      else
        log "WARN: Not found! #{log[:path]}"
      end
    end
  end

  def truncate_file(path, truncated_path)
    num_lines = ChorusConfig.instance['logging.archiver_truncate_number_of_lines']
    log_cmd("tail -n #{num_lines} \"#{path}\" > \"#{truncated_path}\"")
  end

  def add_config_files
    path = "#{ASSEMBLE_ZIP_DIR}/config_files"

    ["#{@chorus_home}/shared/ALPINE_DATA_REPOSITORY/configuration/alpine.runtime.conf",
     "#{@chorus_home}/shared/ALPINE_DATA_REPOSITORY/configuration/alpine.conf"].each do |file|
      if File.exists?(file)
        copy_file(file, path)
      else
        log "WARN: Not found! #{file} \n"
      end
    end
  end

  def add_licences
    path = "#{ASSEMBLE_ZIP_DIR}/licence_files"

    ["#{@chorus_home}/shared/chorus.license", "#{@chorus_home}/shared/ALPINE_DATA_REPOSITORY/alpine.license"].each do |file|
      if File.exists?(file)
        copy_file(file, path)
      else
        log "WARN: Not found! #{file} \n"
      end
    end
  end

  def add_properties
    path = "#{ASSEMBLE_ZIP_DIR}/properties_files"

    ["#{@chorus_home}/shared/chorus.properties",
     "#{@chorus_home}/shared/ALPINE_DATA_REPOSITORY/configuration/deploy.properties"].each do |file|

      if File.exists?(file)
        copy_file(file, path)
      else
        log "WARN: Not found! #{file} \n"
      end
    end

  end

  def add_hdfs_data_sources
    path = "#{ASSEMBLE_ZIP_DIR}/registered_hdfs_data_sources/"
    log_cmd "mkdir -p #{path}"

    filename = path + 'hdfs_data_sources.json'

    json = HdfsDataSource.all.to_json
    File.open(filename, 'w') { |f| f.write(json) }
  end

  def copy_file(from, to)
    log_cmd "mkdir -p #{to}"
    log_cmd("cp #{from} #{to}")
  end

  def zip
    zip_path = "#{ARCHIVE_DIR}/alpine_logs_#{Time.now.to_formatted_s(:number)}.zip"

    zip_file = ZipFileGenerator.new(ASSEMBLE_ZIP_DIR, zip_path)
    zip_file.write()

    `rm -rf #{ASSEMBLE_ZIP_DIR}`
    zip_path
  end
end
