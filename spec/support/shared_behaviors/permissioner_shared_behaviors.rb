shared_examples "a permissioned model" do

  describe "scope" do

    let(:user_a){ User.new(:username => 'user_a') }
    let(:user_b){ User.new(:username => 'user_b') }
    let(:group_a){ Group.create(:name => 'group_a') }
    let(:group_b){ Group.create(:name => 'group_b') }
    let(:scope_a){ ChorusScope.create(:name => 'scope_a') }
    let(:scope_b){ ChorusScope.create(:name => 'scope_b') }
    let(:model_a){ model }

    let(:model_b){
      model.dup.tap{|model| model.save!(:validate => false)}
    }

    before do
      user_a.save!(:validate => false)
      user_b.save!(:validate => false)

      group_a.users << user_a
      group_a.chorus_scopes << scope_a
      group_a.save!

      group_b.users << user_b
      group_b.chorus_scopes << scope_b
      group_b.save!

      co_a = model_a.chorus_object
      co_a.chorus_scope = scope_a
      co_a.save!

      co_b = model_b.chorus_object
      co_b.chorus_scope = scope_b
      co_b.save!
    end

    it "provides a scope filter for a collection of objects" do
      #expect(model.class.filter_by_scope(user_a, model.class.all)).to eq([model_a])
      #expect(model.class.filter_by_scope(user_b, model.class.all)).to eq([model_b])
    end
  end

  it "creates a chorus class and object when created" do
    chorus_class = ChorusClass.find_by_name(model.class.name)
    expect(chorus_class).to_not be_nil

    chorus_object = chorus_class.chorus_objects.find_by_instance_id(model.id)
    expect(chorus_object).to_not be_nil
  end

  # it "initializes the default roles if they exist" do
  #   next if !model.class.const_defined? 'OBJECT_LEVEL_ROLES' # Some permissioned objects don't use object level roles
  #
  #   object_roles_symbols = model.class::OBJECT_LEVEL_ROLES
  #   object_roles = model.object_roles
  #   symbols = object_roles.map {|role| role.name.to_sym }
  #
  #   expect(object_roles_symbols).to eq(symbols)
  # end

  #describe "when adding permissions" do
  #  let (:role) { roles(:a_role) }
  #  let (:permission) { model.class::PERMISSIONS.first }
  #
  #  it "should create .permissions on the chorus class" do
  #    old_count = ChorusClass.find_by_name(model.class.name).permissions.count
  #    model.class.set_permissions_for(role, permission)
  #    new_count = ChorusClass.find_by_name(model.class.name).permissions.count
  #
  #    expect(new_count).to eq(old_count + 1)
  #  end
  #
  #
  #end

  #describe "permission_symbols_for" do
  #  let (:role) { roles(:a_role) }
  #  let (:user) { User.new }
  #  let (:permission) { model.class::PERMISSIONS.first }
  #  it "should_return the correct permission_symbol" do
  #    user.roles << role
  #    model.class.set_permissions_for(role, permission)
  #    expect(model.class.permission_symbols_for(user)).to eq(Array.wrap(permission))
  #  end
  #end

end