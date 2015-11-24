module Authorization
  class Engine < ::Rails::Engine
    isolate_namespace Authorization

    # http://pivotallabs.com/leave-your-migrations-in-your-rails-engines/
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    # Decorators aren't autoloaded: http://edgeguides.rubyonrails.org/engines.html#a-note-on-decorators-and-loading-code
    config.to_prepare do
      Dir.glob(Authorization::Engine.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end

  end
end
