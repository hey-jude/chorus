# Clear all tables related to roles, groups and permissions.
puts 'Clearing data entries for roles, groups and permissions'
Role.delete_all
Group.delete_all
Permission.delete_all
ChorusScope.delete_all
Operation.delete_all
ChorusClass.delete_all
ChorusObject.delete_all
ChorusObjectRole.delete_all
puts '--- DONE ----'


