class AddCurrentObjectsToPermissionsSystem < ActiveRecord::Migration
  def up
    ChorusObject.delete_all
    ChorusObjectRole.delete_all

    load "#{Authorization::Engine.root}/db/permissions_migrator.rb"
    PermissionsMigrator.migrate_5_7
  end
end
