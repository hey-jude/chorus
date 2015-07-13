require 'fileutils'
require 'zip/zip'

module ChorusLogger

  def generate_log_file
      Dir.chdir(Rails.root)
      log_file = compress_logs(generate_logs)
      delete_logs
      return log_file
  end

  def generate_logs
    FileUtils::mkdir_p 'public/logs/'
    Dir.chdir("log")
    log_files = Array.new
    no_of_lines = ChorusConfig.instance['logging.no_of_lines']

    Dir.glob('*.log').each do  |log_file|
      system("tail -#{no_of_lines} #{log_file} > ../public/logs/#{log_file}")
      log_files << log_file
    end
    Dir.chdir('..')
    log_files
  end

  def compress_logs(log_files)
    Dir.chdir('public/logs')

    zipfile_name =  (Time.now.to_s + ".zip").gsub(/\s+/, "_").gsub(/:/,"_")
    Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
      log_files.each do |log_file|
        zipfile.add(log_file, log_file )
      end
    end
    zipfile_name = '/logs/' + zipfile_name
    zipfile_name
  end

  def delete_logs
    Dir.glob('*.log').each do  |log_file|
      FileUtils.rm(log_file)
    end
  end

end
