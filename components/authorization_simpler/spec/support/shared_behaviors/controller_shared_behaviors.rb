shared_examples_for "an action that requires authentication" do |method, action, params = {}|
  describe "when not authenticated" do
    before(:each) do
      log_out
    end

    it "returns unauthorized" do
      send(method, action, params)
      response.code.should == "401"
    end
  end
end