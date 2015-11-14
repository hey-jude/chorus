config = Rails.configuration.database_configuration[Rails.env]
username = config["username"]
password = config["password"]
port = config["port"]
database = config["database"]

url = "postgresql://localhost:#{port}/#{database}"
unless username.blank?
  url << "?user=#{username}"
  unless password.blank?
    url << "&password=#{password}"
  end
end

ENV["QC_DATABASE_URL"] = url