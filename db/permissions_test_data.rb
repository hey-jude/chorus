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
  instance = ChorusObject.where(:instance_id => wspace.id, :chorus_class_id => ChorusClass.find_by_name(wspace.class.name).id).first
  if group_A.users.where(:username => wspace.owner.username).count > 0
    instance.chorus_scope = scope_A
    instance.save!
    puts "adding workspace id = #{wspace.id} to scope A"
    children = %w(jobs milestones memberships workfiles activities events owned_notes comments chorus_views csv_files associated_datasets source_datasets all_imports imports tags)
    children.each do |child|
      puts "   adding #{child} to scope A"
      wspace.send(child).each do |objectz|
        instance = ChorusObject.where(:instance_id => objectz.id, :chorus_class_id => ChorusClass.find_by_name(objectz.class.name).id).first
        instance.chorus_scope = scope_A
        instance.save!
      end
    end
    sa_count = sa_count + 1
  elsif group_B.users.where(:username => wspace.owner.username).count > 0
    instance.chorus_scope = scope_B
    instance.save!
    puts "adding workspace id = #{wspace.id} to scope B"
    children = %w(jobs milestones memberships workfiles activities events owned_notes comments chorus_views csv_files associated_datasets source_datasets all_imports imports tags)
    children.each do |child|
      puts "   adding #{child} to scope B"
      wspace.send(child).each do |objectz|
        instance = ChorusObject.where(:instance_id => objectz.id, :chorus_class_id => ChorusClass.find_by_name(objectz.class.name).id).first
        instance.chorus_scope = scope_B
        instance.save!
      end
    end
    sb_count = sb_count + 1
  else
    puts "Can't find group for user = #{wspace.owner.username}"
  end
end


puts '------------------------------------------'
puts "Added #{sa_count} workspaces to scope_A"
puts "Added #{sb_count} workspaces to scope_B"
puts '------------------------------------------'



User.all.each do |user|
  instance = ChorusObject.where(:instance_id => user.id, :chorus_class_id => ChorusClass.find_by_name(user.class.name).id).first
  if group_A.users.where(:username => user.username).count > 0
    instance.chorus_scope = scope_A
    instance.save!
    puts "adding user id = #{user.id} to scope A"
    children = %w(gpdb_data_sources oracle_data_sources jdbc_data_sources pg_data_sources hdfs_data_sources events gnip_data_sources data_source_accounts memberships owned_jobs activities events open_workfile_events notifications)
    children.each do |child|
      puts "   adding #{child} to scope A"
      user.send(child).each do |objectz|
        instance = ChorusObject.where(:instance_id => objectz.id, :chorus_class_id => ChorusClass.find_by_name(objectz.class.name).id).first
        instance.chorus_scope = scope_A
        instance.save!
      end
    end
    sa_count = sa_count + 1
  elsif group_B.users.where(:username => user.username).count > 0
    instance.chorus_scope = scope_B
    instance.save!
    puts "adding user id = #{user.id} to scope B"
    children = %w(gpdb_data_sources oracle_data_sources jdbc_data_sources pg_data_sources hdfs_data_sources events gnip_data_sources data_source_accounts memberships owned_jobs activities events open_workfile_events notifications)
    children.each do |child|
      puts "   adding #{child} to scope B"
      user.send(child).each do |objectz|
        instance = ChorusObject.where(:instance_id => objectz.id, :chorus_class_id => ChorusClass.find_by_name(objectz.class.name).id).first
        instance.chorus_scope = scope_B
        instance.save!
      end
    end
    sb_count = sb_count + 1
  else
    puts "Can't find group for user = #{user.username}"
  end
end


i = 0

DataSource.all.each do |data_source|
  instance =  ChorusObject.where(:instance_id => data_source.id, :chorus_class_id => data_source.id).first
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


