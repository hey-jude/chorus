class AddCurrentObjectsToPermissionsSystem < ActiveRecord::Migration
  def up
    ChorusObject.delete_all
    ChorusObjectRole.delete_all

    PermissionsMigrator.migrate_5_7
  end
end
