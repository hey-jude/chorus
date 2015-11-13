# KT: A monkeypatch of backbone_fixtures_rails gem's fixture_json_generator.rb file to allow us to place the generated
# fixtures in the frontend gem.

require "json"
require "rspec/core"

class RSpec::Core::ExampleGroup
  def save_fixture(filename, content = JSON.parse(response.body))
    path = Pathname.new(ENV['CHORUS_HOME'] + "/components/frontend/spec/backbone_fixtures/" + filename)
    path.dirname.mkpath unless path.dirname.directory?

    File.open(path, 'w') do |f|
      f.write JSON.pretty_generate(content.as_json)
    end
  end
end