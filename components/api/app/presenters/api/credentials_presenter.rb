module Api
  class CredentialsPresenter < ApiPresenter
    def to_hash
      {
        :username => model.db_username,
        :password => model.db_password
      }
    end

    def complete_json?
      true
    end
  end
end