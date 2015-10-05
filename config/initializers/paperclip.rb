def exception_if_no_imagemagick
  system('identify --version')
  result=$?
  exit_code=result.exitstatus
  if exit_code.eql?(127) # 127 = File Not Found
    raise "Developers must install ImageMagick: brew install imagemagick"
  end
end

# KT: We provide a statically compiled verison of ImageMagick for CentOS, but not for developers in OSX.
platform = `uname`.strip == "Darwin" ? 'osx' : 'centos'
if platform == 'centos'
  Paperclip.options[:command_path] = Rails.root.join('vendor', 'imagemagick', platform)
elsif platform == 'osx'
  exception_if_no_imagemagick
end

# https://github.com/thoughtbot/paperclip/issues/1677#issuecomment-102159964
Paperclip::UploadedFileAdapter.content_type_detector = Paperclip::ContentTypeDetector

# The file extension has to match the filetype as determined by Paperclip::ContentTypeDetector,
# otherwise a "spoofed_media_type" exception is thrown, which cannot be turned off.
# See: https://github.com/thoughtbot/paperclip#security-validations
Paperclip.options[:content_type_mappings] = {
    sql: 'text/plain',
    pmml: 'application/xml',
    am: 'text/plain' # is actually JSON, but we say plain here because it has to match what Paperclip thinks.
}

module Paperclip
  class MediaTypeSpoofDetector

    def spoofed?

      # KT TODO: Do not spoof check empty files.  It's complicated.  I will write a better comment if this is something
      # we will leave in long term.
      return if is_empty?

      if has_name? && has_extension? && media_type_mismatch? && mapping_override_mismatch?
        Paperclip.log("Content Type Spoof: Filename #{File.basename(@name)} (#{supplied_file_content_types}), content type discovered from file command: #{calculated_content_type}. See documentation to allow this combination.")
        true
      end
    end

    def is_empty?
      calculated_content_type == "application/x-empty"
    end
  end
end