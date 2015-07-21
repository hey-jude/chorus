# Module for dealing with permission bitmasks. It adds class methods
# that generate bitmasks or permission bits using the PERMISSIONS
# constant on the class

module Permissioner
  extend ActiveSupport::Concern

  included do
    # after_create :initialize_default_roles, :if => Proc.new { |obj| obj.class.const_defined? 'OBJECT_LEVEL_ROLES' }
    after_initialize :add_scope_id
    after_create :create_chorus_object
    after_destroy :destroy_chorus_object
  end

  # Add scope ID to model object upon initialization
  def add_scope_id
    begin
      if self.class.name == 'Events::Base'
        Chorus.log_debug("No chorus scope found for #{self.class.name}")
        return nil
      elsif self.chorus_scope != nil
          self.instance_variable_set('@chorus_scope_id', self.chorus_scope.id)
          #@attributes['chorus_scope_id'] = self.chorus_scope.id
      else
        self.instance_variable_set('@chorus_scope_id',  ChorusScope.default_chorus_scope.id)
        #@attributes['chorus_scope_id'] = ChorusScope.default_chorus_scope.id
      end
    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
    end

  end

  def chorus_scope_id
    return self.instance_variable_get '@chorus_scope_id'
  end

  # def initialize_default_roles
  #   default_roles = self.class::OBJECT_LEVEL_ROLES.map do |role_symbol|
  #     Role.create(:name => role_symbol.to_s)
  #   end
  #   object_roles << default_roles
  # end

  # Returns true if current user has assigned scope. False otherwise
  def self.user_in_scope?(user)
    if self.is_admin?(user)
      return false
    end
    if user == nil
      # log error and raise exception TBD
      return nil
    else
      groups = user.groups
      groups.each do |group|
        if group.chorus_scope != nil
          return true
        end
      end
    end
    return false
  end

  # Returns true if user has site wide admin role.
  def self.is_admin?(user)
    admin_roles = %w(SiteAdministrator ApplicationAdministrator Admin)
    roles = user.roles
    roles.each do |role|
      if admin_roles.include?(role.name)
        return true
      end
    end
    return false
  end

  # Returns True if the object is within the scope of current user. False otherwise
   def in_scope?(user)
     groups = user.groups
     groups.each do |group|
       if group.chorus_scope == self.chorus_scope
         return true
       end
     end
     return false
   end

  # returns Scope object if the object belongs a scope. Returns nil otherwise.
  def chorus_scope
     chorus_scope_id = self.instance_variable_get '@chorus_scope_id'
     if chorus_scope_id != nil
       return ChorusScope.find(chorus_scope_id)
     else
       add_chorus_scope
     end
  end

  # Add chorus scope to current object if not already assigned
  def add_chorus_scope
    chorus_class = ChorusClass.find_by_name(self.class.name)
    if chorus_class == nil
      Chorus.log_error("Can not find chorus class for #{self.class.name}")
      return nil
    end

    chorus_object = ChorusObject.where(:instance_id => self.id, :chorus_class_id => chorus_class.id).first

    # Add  chorus object if it does nto exists
    if chorus_object == nil
      if self.id != nil
        ChorusObject.create(:chorus_class_id => chorus_class.id, :instance_id => self.id, :chorus_scope_id => ChorusScope.default_chorus_scope.id)
        return ChorusScope.default_chorus_scope
      else
        Chorus.log_error("Can not create chours object for #{self.class.name}. Id attribute is nil")
        return nil
      end
      if chorus_object.chorus_scope == nil
        if chorus_object.parent_object != nil
          return chorus_object.parent_object.chorus_scope
        end
      else
        return chorus_object.chorus_scope
      end
    else
      return chorus_object.chorus_scope
    end

  end

  # Called after model object is created. Created corresponding entry in chorus_objects table
  def create_chorus_object
    chorus_class = ChorusClass.find_or_create_by_name(self.class.name)
    scope_id = ChorusScope.find_by_name('application_realm').id
    ChorusObject.find_or_create_by_chorus_class_id_and_instance_id_and_chorus_scope_id(chorus_class.id, self.id, scope_id)
    # Add scope_id to current object
    #@attributes['chorus_scope_id'] = scope_id
    self.instance_variable_set('@chorus_scope_id', scope_id)
  end

  # Called after a model object is destroyed. Removes corresponding entry from chorus_objects table
  def destroy_chorus_object
    chorus_class = ChorusClass.find_or_create_by_name(self.class.name)
    chorus_object = ChorusObject.where(:instance_id => self.id, :chorus_class_id => chorus_class.id).first
    chorus_object.destroy if chorus_object.nil? == false
  end

  # Ex: Workspace.first.create_permisisons_for(roles, [:edit, :destroy])
  def set_permissions_for(roles, activity_symbol_array)
    permissions = self.class.generate_permissions_for roles, activity_symbol_array
    permissions.each(&:save!)
  end

  # returns an array of workspace level roles
  def object_roles(name=nil)
    self.save! if new_record?

    if name.nil? then self.chorus_object.roles else self.chorus_object.roles.find_by_name(name) end
  end

  def chorus_object
    chorus_class = ChorusClass.find_or_create_by_name(self.class.name)
    ChorusObject.find_or_create_by_chorus_class_id_and_instance_id(chorus_class.id, self.id)
  end

  # returns a parent object if exists. Nil otherwise
  def parent_object
    chorus_object = ChorusObject.where(:instance_id => self.id, :chorus_class_id => ChorusClass.find_by_name(self.class.name)).first
    return chorus_object.parent_object if chorus_object != nil

    return nil

  end

  # Class-level methods invlove setting class-level permissions/roles (vs object-level)
  module ClassMethods


    # Given an collection of objects, returns a collection filterd by user's scope. Removes objects that are not in user's current scope.
    def filter_by_scope(user, objects)

      ret = []
      # This will filter the array of active records without generating an SQL queries.
      user.groups.each do |group|
        if group.chorus_scope != nil
          #binding.pry
          ret << objects.select {|objectz| objectz.chorus_scope_id == group.chorus_scope.id}
        end
      end
      return ret.flatten!

      #ret = []
      #groups = user.groups
      #groups.each do |group|
      #  chorus_scope = group.chorus_scope
      #  if chorus_scope == nil
      #    continue
      #  end
      #  #TODO Prakash : Can user belong to more than one scope?
      #  objects.each do |objectz|
      #    if objectz.chorus_scope == chorus_scope
      #      puts "Adding object id = #{objectz.id} to filtered list"
      #      ret << objectz
      #    end
      #  end
      #end
      #
      #ret
    end

    # returns total # of objects of current class type in scope for current_user
    def count_in_scope(user)
      total = 0
      groups = user.groups
      groups.each do |group|
        chorus_scope = group.chorus_scope
        if chorus_scope == nil
          total = total + count
        else
          chorus_scope = group.chorus_scope
          #TODO: RPG Need to figure out how to handle special cases of sub classes.
          case name
            when 'Workfile'
              total = total + chorus_scope.scoped_objects('ChorusWorkfile').count + chorus_scope.scoped_objects('AlpineWorkfile').count
            else
              total = total + chorus_scope.scoped_objects(name).count
          end
        end
      end
      return total
    end

    # Returns an array of permissions for a give user for the current class type
    def permission_symbols_for(user)
      chorus_class = ChorusClass.find_by_name(self.name)
      operation_name_array = chorus_class.operations.map(&:name)
      #permissions = user.roles.map(&:permissions).flatten.select{|permission| permission.chorus_class == chorus_class}
      permissions = []
      user.roles.each do |role|
        #permissions << Permission.where(:role_id => role.id, :chorus_class => chorus_class).first
        permissions << role.permissions.where(:chorus_class_id => chorus_class.id).first
      end
      activity_symbols = Set.new
      permissions.reject! { |p| p.nil? }
      permissions.each do |permission|
        bits = permission.permissions_mask
        bit_length = bits.size * 8
        bit_length.times do |i|
          activity_symbols.add(operation_name_array[i]) if bits[i] == 1
        end
      end
      activity_symbols.to_a
    end

    # Given an activity, this method returns an integer with that
    # bit set
    def bitmask_for(activity_symbol)
      chorus_class = ChorusClass.find_by_name(self.name)
      operation_name_array = chorus_class.operations.map(&:name)
      activity_index = operation_name_array.index(activity_symbol.to_s)

      raise Authority::AccessDenied if activity_index.nil?
      return 1 << activity_index
    end

    # Given an array of permission symbols, this function
    # returns an integer with the proper permission bits set
    def create_permission_bits_for(activity_symbol_array)
      chorus_class = ChorusClass.find_by_name(self.name)
      operation_name_array = chorus_class.operations.map(&:name)
      bits = 0
      return bits if activity_symbol_array.nil?
      activity_symbol_array.each do |activity_symbol|
        index = operation_name_array.index(activity_symbol)
        raise Authority::AccessDenied if index.nil?

        bits |= ( 1 << index )
      end

      return bits
    end

    # DataSource.create_permissions_for dev_role, [:edit]
    def generate_permissions_for(roles, activity_symbol_array)
      klass = self
      roles, activities = Array.wrap(roles), Array.wrap(activity_symbol_array)
      chorus_class = ChorusClass.find_or_create_by_name(self.name)

      permissions = roles.map do |role|
        permission = Permission.find_or_initialize_by_role_id_and_chorus_class_id(role.id, chorus_class.id)

        # NOTE: This currently over-writes the permissions mask. It would be useful to have
        # (create, add, remove), or, (create, modify) with options
        permission.permissions_mask = klass.create_permission_bits_for(activities)
        permission.role = role
        permission
      end

      permissions
    end

    def set_permissions_for(roles, activity_symbol_array)
      chorus_class = ChorusClass.find_or_create_by_name(self.name)
      chorus_class.permissions << generate_permissions_for(roles, activity_symbol_array)
    end


  end # ClassMethods
end