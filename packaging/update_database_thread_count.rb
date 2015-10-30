component_home = File.expand_path(File.dirname(__FILE__) + '/../')
require File.join(component_home, 'config', 'initializers', 'chorus_config')

# KT TODO: this is a hack, until these script specs get extracted to the `cmd` component
app_root = File.expand_path(File.dirname(__FILE__) + '/../')

chorus_config = ChorusConfig.new(app_root)

max_connections = chorus_config["database_threads"]

print max_connections