require 'securerandom'
require 'pathname'
require 'fileutils'

namespace :development do
  desc "Generate config/secret.token which is used for signing cookies"
  task :generate_secret_token do
    secret_token_file = Pathname.new(__FILE__).dirname.join("../../config/secret.token")
    secret_token_file.open("w") { |f| f << SecureRandom.hex(64) } unless secret_token_file.exist?
    secret_token_file.chmod(0600)
  end

  desc "Generate config/secret.key which is used for encrypting saved database passwords"
  task :generate_secret_key do
    secret_key_file = Pathname.new(__FILE__).dirname.join("../../config/secret.key")
    next if secret_key_file.exist?

    passphrase = Random.new.bytes(32)
    secret_key = Base64.strict_encode64(OpenSSL::Digest.new("SHA-256", passphrase).digest)
    secret_key_file.open("w") { |f| f << secret_key }
    secret_key_file.chmod(0600)
  end

  desc "Copy database.yml.example to database.yml"
  task :generate_database_yml do
    CBRA_ROOT = Rails.root
    database_yml_example = CBRA_ROOT.join("packaging/database.yml.example")
    database_yml = CBRA_ROOT.join("config/database.yml")
    FileUtils.cp(database_yml_example.to_s, database_yml.to_s) unless database_yml.exist?
  end

  # KT see comments here: http://blog.pivotal.io/labs/labs/leave-your-migrations-in-your-rails-engines
  desc "reset the database, drop, create, & migrate"
  task :db_reset => [:environment, "db:drop", "db:create", "db:migrate"]

  desc "Initialize the database and create the database user used by Chorus"
  task :init_database => [:generate_database_yml] do
    CBRA_ROOT = Rails.root

    postgres_port = `ruby #{File.join(CBRA_ROOT, 'packaging', 'get_postgres_port.rb')}`.chomp

    # Give the poor developer a clue as to what is wrong!
    if CBRA_ROOT.join("postgres-db").exist?
      p "The postgres-db directory already exists, so exiting."
      next
    end

    ENV['DYLD_LIBRARY_PATH'] = "#{CBRA_ROOT}/postgres/lib"
    ENV['LD_LIBRARY_PATH'] = "#{CBRA_ROOT}/postgres/lib"
    ENV['CHORUS_HOME'] = "#{CBRA_ROOT}"
    `#{CBRA_ROOT}/postgres/bin/initdb -D #{CBRA_ROOT}/postgres-db -E utf8`
    `#{CBRA_ROOT}/packaging/chorus_control.sh start postgres`
    `#{CBRA_ROOT}/postgres/bin/createuser -hlocalhost -p #{postgres_port} -sdr postgres_chorus`

    Rake::Task["development:db_reset"].invoke
    Rake::Task["db:seed_permissions"].invoke
    Rake::Task["db:seed_development"].invoke
    `#{CBRA_ROOT}/packaging/chorus_control.sh stop postgres`
  end

  desc "Initialize development environment.  Includes initializing the database and creating secret tokens"
  task :init => [:generate_secret_token, :generate_secret_key, :init_database]
end