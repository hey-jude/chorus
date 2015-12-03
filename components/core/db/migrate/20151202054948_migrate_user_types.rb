class MigrateUserTypes < ActiveRecord::Migration
  def change
    User.where(:user_type => nil).each do |user|
      if user.developer == true
        user.update_columns(:user_type => License::USERS_ANALYTICS_DEVELOPER)
      else
        user.update_columns(:user_type => License::USERS_COLLABORATOR)
      end
    end
  end
end
