component_home = File.expand_path(File.dirname(__FILE__) + '/../')
require File.join(component_home, 'app', 'models', 'chorus_config')

# KT TODO: this is a hack, until these script specs get extracted to the `cmd` component
app_root = File.expand_path(File.dirname(__FILE__) + '../../../../')

chorus_config = ChorusConfig.new(app_root)

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
