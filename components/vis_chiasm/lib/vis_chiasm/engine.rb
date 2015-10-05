module VisChiasm
  class Engine < ::Rails::Engine
    # isolate_namespace VisChiasm

    config.to_prepare do
      Dir.glob(VisChiasm::Engine.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end
  end
end
