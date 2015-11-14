shared_examples "a scoped endpoint" do

  it "calls filter_by_scope if user is in a scope" do
    test_scope = ChorusScope.create(:name => "a scope")
    test_group = Group.create(:name => "a group")
    test_group.users << user
    test_group.chorus_scope = test_scope
    test_group.save!

    mock.proxy(klass).filter_by_scope.with_any_args

    get action, params
  end
end