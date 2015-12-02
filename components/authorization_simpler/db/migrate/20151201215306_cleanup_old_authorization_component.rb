class CleanupOldAuthorizationComponent < ActiveRecord::Migration

  def up
    if table_exists?("chorus_classes")
      drop_table :chorus_classes
    end

    if table_exists?("chorus_objects")
      drop_table :chorus_objects
    end

    if table_exists?("chorus_object_roles")
      drop_table :chorus_object_roles
    end

    if table_exists?("chorus_scopes")
      drop_table :chorus_scopes
    end

    if table_exists?("groups")
      drop_table :groups
    end

    if table_exists?("groups_users")
      drop_table :groups_users
    end

    if table_exists?("groups_roles")
      drop_table :groups_roles
    end

    if table_exists?("operations")
      drop_table :operations
    end

    if table_exists?("permissions")
      drop_table :permissions
    end

    if table_exists?("roles")
      drop_table :roles
    end

    if table_exists?("roles_users")
      drop_table :roles_users
    end

    if column_exists? :memberships, :role
      remove_column :memberships, :role
    end

    # These are the schema_migrations associated with the old authorization component.  Located here:
    # components/authorization/db/migrate/*
    # ... deleting these will allow us to re-run the migrations from the original Authorization component.  So, we don't
    # need to recreate its state in the "down" method.
    %w( 20150317175615
        20150317192400
        20150317210633
        20150319185945
        20150324215343
        20150325182454
        20150403194533
        20150410181702
        20150415230019
        20150417192725
        20150601150023
        20150603113221
        20150604140318
        20150604142252
        20150918193919
        20151021053828
        20151026205156).each do |version|
      ActiveRecord::Base.connection.execute("DELETE FROM schema_migrations WHERE version='#{version}'")
    end
  end

  def down
  end
end


