# Clear all tables related to roles, groups and permissions.
puts 'Clearing data entries for roles, groups and permissions'
connection = ActiveRecord::Base.connection
#Role.destroy_all
connection.execute("DELETE FROM roles")
connection.execute("DELETE FROM roles_users")

#Group.destroy_all
connection.execute("DELETE FROM groups")
connection.execute("DELETE FROM groups_roles")
connection.execute("DELETE FROM groups_users")

#Permission.destroy_all
connection.execute("DELETE FROM permissions")

#ChorusScope.destroy_all
connection.execute("DELETE FROM chorus_scopes")

#Operation.destroy_all
connection.execute("DELETE FROM operations")

#ChorusClass.destroy_all
connection.execute("DELETE FROM chorus_classes")

#ChorusObject.destroy_all
connection.execute("DELETE FROM chorus_objects")

#ChorusObjectRole.destroy_all
connection.execute("DELETE FROM chorus_object_roles")
puts '--- DONE ----'


