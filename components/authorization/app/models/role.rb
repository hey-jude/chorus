class Role < ActiveRecord::Base

  attr_accessible :name, :description

  validates :name, :presence => true, :uniqueness => true

  has_and_belongs_to_many :users, -> { uniq }
  has_and_belongs_to_many :groups, -> { uniq }
  has_many :permissions, :dependent => :destroy
  has_many :chorus_object_roles, :dependent => :destroy
  has_many :chorus_objects, :through => :chorus_object_roles

  # Delete HABTM association objects
  before_destroy { groups.clear }
  before_destroy { users.clear }


  def permissions_for(class_name)
    chorus_class = ChorusClass.find_by_name(class_name.camelize)
    ret = Set.new
    if chorus_class == nil
      #raise exception
      return nil
    else
      perm_obj = permissions.where(:chorus_class_id => chorus_class.id).first
      if perm_obj == nil
        #raise exception
        return nil
      else
        operations = chorus_class.class_operations
        bits = perm_obj.permissions_mask
        bit_length = bits.size * 8
        bit_length.times do |i|
          ret.add(operations[i].to_sym) if bits[i] == 1
        end

      end

    end

    ret.to_a

  end
end