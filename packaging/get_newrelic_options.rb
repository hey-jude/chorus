component_home = File.expand_path(File.dirname(__FILE__) + '/../')
require File.join(component_home, 'app', 'models', 'chorus_config')

# KT TODO: this is a hack, until these script specs get extracted to the `cmd` component
app_root = File.expand_path(File.dirname(__FILE__) + '../../../../')

chorus_config = ChorusConfig.new(app_root)

puts "export CHORUS_NEWRELIC_ENABLED=#{chorus_config["newrelic.enabled"]}"
puts "export CHORUS_NEWRELIC_LICENSE_KEY=\"#{chorus_config["newrelic.license_key"]}\""
