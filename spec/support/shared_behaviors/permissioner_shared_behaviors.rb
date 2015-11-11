shared_examples "a permissioned model" do

  describe "associations" do
    it "allows the model to belong in multiple scopes" do
      expect { model_a.chorus_scopes << [scope_a, scope_b] }.not_to raise_error
    end
  end

  describe "scope" do

    let(:user_a){ User.new(:username => 'user_a') }
    let(:user_b){ User.new(:username => 'user_b') }
    let(:group_a){ Group.create(:name => 'group_a') }
    let(:group_b){ Group.create(:name => 'group_b') }
    let(:scope_a){ ChorusScope.create(:name => 'scope_a') }
    let(:scope_b){ ChorusScope.create(:name => 'scope_b') }
    let(:model_a){ model }

    let(:model_b){
      model.dup.tap do |model|
        # try to avoid PG constraints as they aren't important for this test
        model.name = model.name + "_different" if model.respond_to?(:name) && model.class != HdfsEntry && model.class != CsvFile
        model.username = model.username + "_diferent" if model.respond_to?(:username) && model.class != HdfsEntry && model.class != HdfsDataSource
        model.path = model.path + "_different" if model.class == HdfsEntry && model.class != CsvFile
        model.save!(:validate => false)
      end
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
      co_a.chorus_scopes << scope_a
      co_a.save!

      co_b = model_b.chorus_object
      co_b.chorus_scopes << scope_b
      co_b.save!
    end

    it "provides a scope filter for a collection of objects" do
      expect(model.class.filter_by_scope(user_a, model.class.all)).to eq([model_a])
      expect(model.class.filter_by_scope(user_b, model.class.all)).to eq([model_b])
    end
  end

  it "creates a chorus class and object when created" do
    chorus_class = ChorusClass.find_by_name(model.class.name)
    expect(chorus_class).to_not be_nil

    chorus_object = chorus_class.chorus_objects.find_by_instance_id(model.id)
    expect(chorus_object).to_not be_nil
  end
end