rails_root = File.expand_path(File.dirname(__FILE__) + '/../')
require File.join(rails_root, 'config', 'initializers', 'chorus_config')
chorus_config = ChorusConfig.new(rails_root)

java_options = chorus_config["java_options"].gsub(/-Xms\S+/, '')

jruby_options = java_options.split(" ").map do |option|
  if ["-server", "-client"].include?(option)
    "-#{option}"
  else
    "-J#{option}"
  end
end

unless ENV['RAILS_ENV'] == 'production'
  jruby_options << '-J-Dapple.awt.UIElement=true'
end

print jruby_options.join(" ")
