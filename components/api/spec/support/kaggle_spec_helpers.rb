# KT TODO Prakash says to move all Kaggle stuff into separate component
module KaggleSpecHelpers
  def kaggle_users_api_result
    JSON.parse(File.read("#{ENV['CHORUS_HOME']}/spec/fixtures/kaggleSearchResults.json"))['users'].map { |data|
      Kaggle::User.new(data)
    }
  end
end