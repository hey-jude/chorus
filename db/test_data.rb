
puts "============== FOLLOWING IS FOR TESTING PURPOSR ONLY ================="
puts ''
puts '--- Adding scopes ----'
#for testing only
scope_A = ChorusScope.create(:name => 'scope_A')
scope_B = ChorusScope.create(:name => 'scope_B')

puts ''
puts '---- Adding groups ----'
#for testing only
group_A = Group.create(:name => 'group_A')
group_B = Group.create(:name => 'group_B')

puts ''
puts '---- Assiging scopes to groups ----'
group_A.chorus_scope = scope_A
group_A.save!
group_B.chorus_scope = scope_B
group_B.save!

puts ''
puts '---- Randomly assigning workspace and data sources to scopes ----'
i = 0

User.all.each do |user|

  if i.even?
    puts "Adding #{user.username} to group A"
    group_A.users << user
  else
    puts "Adding #{user.username} to group B"
    group_B.users << user
  end
  i = i + 1

end

sa_count = 0
sb_count = 0

Workspace.all.each do |wspace|
  instance = ChorusObject.where(:instance_id => wspace.id, :chorus_class_id => workspace_class.id).first
  if group_A.users.where(:username => wspace.owner.username).count > 0
    instance.chorus_scope = scope_A
    instance.save!
    puts "adding workspace id = #{wspace.id} to scope A"
    sa_count = sa_count + 1
  elsif group_B.users.where(:username => wspace.owner.username).count > 0
    instance.chorus_scope = scope_B
    instance.save!
    puts "adding workspace id = #{wspace.id} to scope B"
    sb_count = sb_count + 1
  else
    puts "Can't find group for user = #{wspace.owner.username}"
  end
end


puts '------------------------------------------'
puts "Added #{sa_count} workspaces to scope_A"
puts "Added #{sb_count} workspaces to scope_B"
puts '------------------------------------------'


i = 0

DataSource.all.each do |data_source|
  instance =  ChorusObject.where(:instance_id => data_source.id, :chorus_class_id => datasource_class.id).first
  if group_A.users.where(:username => data_source.owner.username).count > 0
    instance.chorus_scope = scope_A
    instance.save!
    puts "adding data_source id = #{data_source.id} to scope A"
    sa_count = sa_count + 1
  elsif group_B.users.where(:username => data_source.owner.username).count > 0
    instance.chorus_scope = scope_B
    instance.save!
    puts "adding data_source id = #{data_source.id} to scope B"
    sb_count = sb_count + 1
  else
    puts "Can't find group for user = #{data_source.owner.username}"
  end
end
