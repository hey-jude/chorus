Dashboard::WorkspaceActivity.class_eval do

  def access_checker
    if @access_checker.nil?
      @access_checker = Api::WorkspacesController.new
    end

    @access_checker
  end
end