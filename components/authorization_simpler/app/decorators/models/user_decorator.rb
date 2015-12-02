User.class_eval do
  # KT: The 'User#roles' attribute is a special Rails Postgres 'array' attribute type ...
  # http://blog.arkency.com/2014/10/how-to-start-using-arrays-in-rails-with-postgresql/

  # KT TODO: what to do about the scope :admin in core -> user.rb
  scope :admins, -> { where("'admin' = ANY (roles) OR admin = true") }

  # NB: Don't modify the 'roles' array directly, use these methods ...
  # http://stackoverflow.com/questions/17283854/new-data-not-persisting-to-rails-array-column-on-postgres
  def add_role(role)
    enforce_roles_array(role)
    self.roles = self.roles + [role]
  end
  def remove_role(role)
    enforce_roles_array(role)
    self.roles = self.roles - [role]
  end

  private

  # KT this is not a validation, because users will never be able to edit these strings directly -- therefore,
  # for devs, fail fast and make it obvious.
  def enforce_roles_array(role)
    unless Authorization::ROLES.include?(role)
      raise 'User#roles must only include strings included in Authorization::ROLES.'
    end
  end
end
