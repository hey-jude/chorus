# Clear all tables related to roles, groups and permissions.
puts 'Clearing data entries for roles, groups and permissions'
Role.destroy_all

Group.destroy_all

Permission.destroy_all

ChorusScope.destroy_all

Operation.destroy_all

ChorusClass.destroy_all

ChorusObject.destroy_all

ChorusObjectRole.destroy_all

puts '--- DONE ----'


