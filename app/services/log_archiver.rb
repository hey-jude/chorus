require 'fileutils'
require 'zip_file_generator'

module LogArchiver

  ARCHIVE_DIR = "#{Rails.root}/tmp/log_archiver"
  ASSEMBLE_ZIP_DIR = "#{ARCHIVE_DIR}/tmp"

  # KT: from Nate ... see: https://alpine.atlassian.net/browse/DEV-11637
  # Alpine.log > chorus user's home directory
  # AlpineAgent_x.log > chorus user's home directory
  # install.log > /tmp/install.log
  # pgadmin.log (called server.log) > $CHORUS_HOME/shared/db
  # tomcat logs > $CHORUS_HOME/alpine-current/apache-tomcat-7.0.41/logs

  # KT: I see these files in this location: AlpineHadoopRestClient.log, Alpine.log
  ALPINE_LOGS = {path: "#{Dir.home}",
                 archive_path: "#{ASSEMBLE_ZIP_DIR}/alpine_logs"}

  ALPINE_INSTALL_LOGS = {path: "/tmp/install.log",
                         archive_path: "#{ASSEMBLE_ZIP_DIR}/alpine_install_logs"}

  POSTGRES_LOGS = {path: "#{(`echo $CHORUS_HOME`).to_s.strip}/shared/db/server.log",
                   archive_path: "#{ASSEMBLE_ZIP_DIR}/postgres_logs"}

  TOMCAT_LOGS = {path: "#{(`echo $CHORUS_HOME`).to_s.strip}/alpine-current/apache-tomcat-7.0.41/logs",
                 archive_path: "#{ASSEMBLE_ZIP_DIR}/tomcat_logs"}

  CHORUS_LOGS = {path: "#{Rails.root}/log",
                 archive_path: "#{ASSEMBLE_ZIP_DIR}/chorus_logs"}

  LOGS = [CHORUS_LOGS, ALPINE_LOGS, ALPINE_INSTALL_LOGS, POSTGRES_LOGS, TOMCAT_LOGS]

  def create_archive
    `mkdir -p #{ASSEMBLE_ZIP_DIR}`

    start_time = Time.now
    log "Log archiver started at #{start_time.to_formatted_s(:long)}"

    # alpine_logs_20150720150924.zip
    zip_path = "#{ARCHIVE_DIR}/alpine_logs_#{Time.now.to_formatted_s(:number)}.zip"
    log "... generating: #{zip_path}"

    truncate_logs_into_assemble_zip_dir

    log "Zipping, after: #{Time.now - start_time}."
    @log_archiver_logfile.close()

    zip(zip_path)

    `rm -rf #{ASSEMBLE_ZIP_DIR}`

    zip_path
  end

  def truncate_logs_into_assemble_zip_dir

    LOGS.each do |log|
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

            if exclusion_regexes.any? {|regex| regex.match(basename) }
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

  def zip(path)

    # See: https://github.com/rubyzip/rubyzip/issues/214
    Dir.chdir(ASSEMBLE_ZIP_DIR)

    zip_file = ZipFileGenerator.new(ASSEMBLE_ZIP_DIR, path)
    zip_file.write()

    Dir.chdir(Rails.root)
  end

  def truncate_file(path, truncated_path)
    num_lines = ChorusConfig.instance['logging.archiver_truncate_number_of_lines']
    log_cmd("tail -n #{num_lines} \"#{path}\" > \"#{truncated_path}\"")
  end

  def log_cmd(cmd)
    log cmd
    log `#{cmd}`
  end

  def log(msg)
    @log_archiver_logfile ||= File.new("#{ASSEMBLE_ZIP_DIR}/log_archiver.log", "w+")
    unless msg.blank?
      logger.debug msg
      @log_archiver_logfile.write("#{msg}\n")
      @log_archiver_logfile.flush
    end
  end

end
