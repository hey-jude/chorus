# KT TODO: does this file work, since the ImagesController is broken?
module Api
  class UserImagesController < ImagesController
    protected

    def load_entity
      @entity = User.find(params[:user_id])
      @user = @entity
    end

    def authorize_create!
      # Remove this method when 'authorize_create!' is taken out of
      # ImagesController
      Authority.authorize! :create, @user, current_user, {:or => :current_user_is_referenced_user}
    end

    def authorize_show!
      true
    end
  end
end