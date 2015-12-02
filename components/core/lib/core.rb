require 'action_mailer'
require 'active_record'
require 'protected_attributes'
require 'activerecord-jdbcpostgresql-adapter'
require 'queue_classic'
require 'attr_encrypted'
require 'clockwork'
require 'honor_codes'
require 'openssl'
require 'logger-syslog'
require 'net-ldap'
require 'newrelic_rpm'
require 'paperclip'
require 'premailer'
require 'nokogiri'
require 'render_anywhere'
require 'sequel'
require 'sunspot_rails'
require 'will_paginate'
require 'chorusgnip'

module Core
  require "core/engine"
end
