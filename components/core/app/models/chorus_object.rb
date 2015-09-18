class ChorusObject < ActiveRecord::Base
  attr_accessible :chorus_class_id, :instance_id, :parent_class_id, :parent_class_name, :permissions_mask, :owner_id, :parent_id, :chorus_scope_id

  validates_uniqueness_of :instance_id, scope: [:chorus_class_id, :chorus_scope_id]

  belongs_to :chorus_class
  belongs_to :chorus_scope
  belongs_to :owner, :class_name => "User"
  has_many :chorus_object_roles, -> { uniq }, :dependent => :destroy
  #has_many :roles, :through => :chorus_object_roles
  #has_many :permissions, :through => :roles

  # This is for debugging purposes only. It won't return AR objects.
  def show_roles_and_users
    chorus_object_roles.map(&:role).uniq.map do |r|
      [r.name, users_for_role(r).map(&:username)]
    end
  end

  # Due to the design of the schema, Rails doesn't play well with the roles association,
  # So we have to do some manual building of objects
  def roles_for_user(user)
    role_ids = self.chorus_object_roles.where(:user_id => user.id).map(&:role_id)
    Role.find(role_ids)
  end

  def users_for_role(role)
    user_ids = self.chorus_object_roles.where(:role_id => role.id).map(&:user_id)
    User.find(user_ids)
  end

  def add_user_to_object_role(user, role)
    attributes = chorus_object_role_attributes_for(user, role)
    unless ChorusObjectRole.where(attributes).first
      self.chorus_object_roles.create(attributes)
    end
  end

  def remove_user_from_object_role(user, role)
    attributes = chorus_object_role_attributes_for(user, role)
    chorus_object_role = self.chorus_object_roles.where(attributes).first
    if chorus_object_role
      ChorusObjectRole.destroy(chorus_object_role)
      self.chorus_object_roles.destroy(chorus_object_role)
    end
  end

  def referenced_object
    actual_class = chorus_class.name.camelize.constantize
    actual_class.find(instance_id)
  end

  # returns true of current object has a parent. False otherwise
  def has_parent?
    parent_id != nil
  end

  #returns the instance of the parent object if parent exists. Returns nil otherwise.
  def parent_object
    if has_parent?
      actual_class = parent_class_name.camelize.constantize
      actual_class.find(parent_id)
    else
      nil
    end
  end

  private

  def chorus_object_role_attributes_for(user, role)
    { :chorus_object_id => self.id, :user_id => user.id, :role_id => role.id }
  end
end
