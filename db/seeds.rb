# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

ActiveRecord::Base.connection.schema_cache.clear!

class BlackholeSession
  def initialize(*args)
  end

  def method_missing(*args)
  end
end

Sunspot.session = BlackholeSession.new

# --- USERS ---

unless User.where(:username => "chorusadmin").present?
  puts "Creating chorusadmin user..."
  user = User.new(
    :username => "chorusadmin",
    :first_name => "Chorus",
    :last_name => "Admin",
    :email => "chorusadmin@example.com",
    :password => "secret",
    :password_confirmation => "secret"
  )
  user.admin = true
  user.save!
end
chorusadmin = User.find_by_username("chorusadmin")

# Seed roles groups and permissions
admin_role = Role.create(:name => "Admin")
developer_role = Role.create(:name => "Developer")
admin_role.users << chorusadmin

User.set_permissions_for [admin_role], [:create, :destroy, :ldap, :update]
Events::Note.set_permissions_for [admin_role], [:destroy, :demote_from_insight, :update]
Workspace.set_permissions_for [admin_role], [:show, :update, :destroy, :admin]
Workspace.set_permissions_for [developer_role], [:show, :update, :create_workflow]
