module Frontend
  class Engine < ::Rails::Engine
    isolate_namespace Frontend

    # Initializer to combine this engine's static assets with the static assets of the hosting site.
    # http://stackoverflow.com/questions/4266232/rails-3-engine-static-assets
    initializer "static assets" do |app|
      app.middleware.insert_before(::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public")
    end

  end
end
