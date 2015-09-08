class UserImagesController < ImagesController
  protected

  def load_entity
    @entity = User.find(params[:user_id])
    @user = @entity
  end

  def authorize_create!
    Authority.authorize! :update, @user, current_user, { :or => :current_user_is_referenced_user }
  end

  def authorize_show!
    true
  end
end
