module VisChiasm
  class Engine < ::Rails::Engine

    # http://pivotallabs.com/leave-your-migrations-in-your-rails-engines/
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end

      ActiveRecord::Tasks::DatabaseTasks.migrations_paths = ActiveRecord::Tasks::DatabaseTasks.migrations_paths | app.config.paths['db/migrate'].to_a
      ActiveRecord::Migrator.migrations_paths = ActiveRecord::Migrator.migrations_paths | app.config.paths['db/migrate'].to_a
    end

  end
end
