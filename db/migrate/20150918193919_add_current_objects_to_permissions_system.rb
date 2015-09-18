class AddCurrentObjectsToPermissionsSystem < ActiveRecord::Migration
  def up
    ChorusObject.delete_all
    ChorusObjectRole.delete_all

    User # This line is surprisingly necessary. Without it, Rails will incorrectly think that
         # the User class is double 'include'ing inside its Concern
    PermissionsMigrator.migrate_5_7
  end
end
