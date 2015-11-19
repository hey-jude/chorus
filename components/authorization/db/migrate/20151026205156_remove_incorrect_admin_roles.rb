class RemoveIncorrectAdminRoles < ActiveRecord::Migration
  def up
    admin_role = Role.find_by(:name => "Admin")
    manager_role = Role.find_by(:name => "ApplicationManager")
    site_admin_role = Role.find_by(:name => "SiteAdministrator")

    User.all.each do |user|
      if user.admin? == false && Permissioner.is_admin?(user)
        user.roles.delete(admin_role, manager_role, site_admin_role)
      end
    end
  end

  def down
    # not reversible
  end
end
