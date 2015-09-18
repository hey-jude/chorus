require 'rexml/document'

component_home = File.expand_path(File.dirname(__FILE__) + '/../')
require File.join(component_home, 'app', 'models', 'chorus_config')

# KT TODO: this is a hack, until these script specs get extracted to the `cmd` component
app_root = File.expand_path(File.dirname(__FILE__) + '../../../../')

chorus_config = ChorusConfig.new(app_root)

jetty_xml_file = File.join(chorus_home, 'vendor', 'jetty', 'jetty.xml')

xml_doc = REXML::Document.new(File.new(jetty_xml_file))
max_threads = REXML::XPath.first(xml_doc, "/Configure/Set[@name='ThreadPool']/New/Set[@name='maxThreads']")
max_threads.text = chorus_config['webserver_threads']

min_threads = REXML::XPath.first(xml_doc, "/Configure/Set[@name='ThreadPool']/New/Set[@name='minThreads']")
if min_threads.text.to_i > chorus_config['webserver_threads'].to_i
  min_threads.text = chorus_config['webserver_threads']
end

File.open(jetty_xml_file, 'w') do |f|
  f.write(xml_doc.to_s)
end