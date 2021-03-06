ActiveRecord::Base.connection.schema_cache.clear!

class BlackholeSession
  def initialize(*args)
  end

  def method_missing(*args)
  end
end

Sunspot.session = BlackholeSession.new

load Authorization::Engine.root.join('db', 'permissions_seeds.rb')
# --- USERS ---

unless User.where(:username => "chorusadmin").present?
  puts "Creating chorusadmin user..."
  user = User.new(
    :username => "chorusadmin",
    :first_name => "Chorus",
    :last_name => "Admin",
    :email => "chorusadmin@example.com",
    :password => "secret",
    :password_confirmation => "secret",
  )
  user.save!
end

chorusadmin = User.find_by_username("chorusadmin")
chorusadmin.admin = true
chorusadmin.save!
site_admin_role = Role.find_or_create_by(:name => 'site_administrator'.camelize)
admin_role = Role.find_or_create_by(:name => 'admin'.camelize)

site_admin_role.users << chorusadmin if chorusadmin && !site_admin_role.users.include?(chorusadmin)
admin_role.users << chorusadmin if chorusadmin && !admin_role.users.include?(chorusadmin)


# Add chorusadmin to default group
default_group = Group.find_or_create_by(:name => 'default_group')
chorusadmin.groups << default_group

