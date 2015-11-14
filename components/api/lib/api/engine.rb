module Api
  class Engine < ::Rails::Engine
    isolate_namespace Api

    # Decorators aren't autoloaded: http://edgeguides.rubyonrails.org/engines.html#a-note-on-decorators-and-loading-code
    config.to_prepare do
      Dir.glob(Api::Engine.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end

  end
end
