rails_root = File.expand_path(File.dirname(__FILE__) + '/../')
require File.join(rails_root, 'config', 'initializers', 'chorus_config')
chorus_config = ChorusConfig.new(rails_root)

puts "export CHORUS_NEWRELIC_ENABLED=#{chorus_config["newrelic.enabled"]}"
puts "export CHORUS_NEWRELIC_LICENSE_KEY=\"#{chorus_config["newrelic.license_key"]}\""
