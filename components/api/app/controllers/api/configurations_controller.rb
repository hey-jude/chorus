
# KT TODO: this is gross
require_relative '../../../../../version'

module Api
  class ConfigurationsController < ApiController
    skip_before_filter :require_login, :only => :version

    def show
      present(ChorusConfig.instance)
    end

    def version
      render :inline => build_string
    end

    def build_string
      f = File.join(Rails.root, 'version_build')
      File.exists?(f) ? File.read(f) : Chorus::VERSION::STRING
    end
  end
end