# class MessageMiddlewareCommon
#   def call(env)
#     [200, {"Content-Type" => "text/html"}, [IO.read("public/translations/messages_en.properties")]]
#   end
# end
#
# class MessageMiddlewareVisualizations
#   def call(env)
#     [200, {"Content-Type" => "text/html"}, [IO.read("public/translations/visualizations_messages_en.properties")]]
#   end
# end
#
class DummyMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    path = env['PATH_INFO']

    fake_headers =
      case path
      when /\.js$/
        nil
      when /\/.*(image|thumbnail)/, /\.(png|gif|jpg)/
        { "Content-Type" => "image/jpeg" }
      when /fonts/
        { "Content-Type" => "application/octet-stream" }
      when /\/file\/[^\/]+$/
        { "Content-Type" => "text/plain" }
      when /\/edc\//
        { "Content-Type" => "application/json" }
      end

    if fake_headers
      [200, fake_headers, []]
    else
      @app.call(env)
    end
  end
end

Jasmine.configure do |config|
  config.boot_dir = Frontend::Engine.root.join('spec/javascripts/support/jasmine-boot').to_s
  config.boot_files = lambda { [Frontend::Engine.root.join('spec/javascripts/support/jasmine-boot/boot.js').to_s] }

  # config.add_rack_path('/translations/messages_en.properties', lambda { MessageMiddlewareCommon.new })
  # config.add_rack_path('/translations/visualizations_messages_en.properties', lambda { MessageMiddlewareVisualizations.new })
  config.add_rack_path('/__fixtures', lambda { BackboneFixtures::FixtureMiddleware.new })
  config.add_rack_app(DummyMiddleware)
end