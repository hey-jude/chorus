module Admin
  class UsersController < AdminController
    add_breadcrumb "Admin", :root_path

    def index
      add_breadcrumb "Users", users_path
      @users = User.all
    end

    def show
      add_breadcrumb "Users", users_path
      @user = User.find(params[:id])
      add_breadcrumb "User: #{@user.username}", user_path(@user)
    end
  end
end