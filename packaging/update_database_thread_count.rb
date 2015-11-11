rails_root = File.expand_path(File.dirname(__FILE__) + '/../')
require File.join(rails_root, 'config', 'initializers', 'chorus_config')
chorus_config = ChorusConfig.new(rails_root)

max_connections = chorus_config["database_threads"]

print max_connections