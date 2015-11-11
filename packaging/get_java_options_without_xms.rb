rails_root = File.expand_path(File.dirname(__FILE__) + '/../')
require File.join(rails_root, 'config', 'initializers', 'chorus_config')
chorus_config = ChorusConfig.new(rails_root)

print chorus_config["java_options"].gsub(/-Xms\S+/, '')