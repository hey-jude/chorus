require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = '../../spec/vcr_cassettes'
  c.hook_into :fakeweb
  c.default_cassette_options = { :record => :new_episodes }

  c.filter_sensitive_data('<SUPPRESSED_KAGGLE_API_KEY>', :filter_kaggle_api_key) do |interaction|
    ChorusConfig.instance['kaggle']['api_key']
  end

  # KT: useful if you suspect tests are failing because of VCR
  # c.debug_logger = File.open("#{Rails.root}/log/vcr.log", 'w')
end

def record_with_vcr(tape_name = nil, &block)
  default_tape_name = CGI.escape(example.full_description.downcase)
  VCR.use_cassette(tape_name || default_tape_name, &block)
end
