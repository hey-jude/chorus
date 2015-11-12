class MigrateChorusScopeToChorusScopes < ActiveRecord::Migration
  def up
    default_scope_id = ChorusScope.where(:name => "application_realm").pluck(:id).first
    attribute_columns = "(chorus_scope_id, chorus_object_id)"
    chorus_object_ids = ChorusObject.pluck(:id)
    rows = create_rows(default_scope_id, chorus_object_ids)

    ChorusObject.connection.execute "INSERT INTO chorus_objects_scopes #{attribute_columns} VALUES #{rows.join(", ")}" if rows.any?
  end

  def down
    # not reversible
  end

  private

  def create_rows(scope_id, object_ids)
    object_ids.map do |id|
      "(#{scope_id}, #{id})"
    end
  end
end
