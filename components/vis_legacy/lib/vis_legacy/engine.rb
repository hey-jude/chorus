module VisLegacy
  class Engine < ::Rails::Engine
    # isolate_namespace VisLegacy

    config.to_prepare do
      Dir.glob(VisLegacy::Engine.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end
  end
end
