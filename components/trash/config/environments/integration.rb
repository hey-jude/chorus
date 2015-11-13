# KT TODO: scrub 'integration' environment from app ...

require_relative 'test'

Rails.application.configure do
  config.action_dispatch.show_exceptions = false # make sure capybara server middleware gets exceptions
  config.allow_concurrency = true
  config.action_controller.allow_forgery_protection = true
end
