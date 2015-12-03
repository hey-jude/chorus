require "#{Rails.root}/version"
require 'honor_codes/core'

class License
  OPEN_CHORUS = 'openchorus'
  VENDOR_ALPINE = 'alpine'
  VENDOR_PIVOTAL = 'pivotal'
  LEVEL_EXPLORER = 'explorer'
  LEVEL_BASECAMP = 'basecamp'
  LEVEL_SUMMIT = 'summit'
  USERS_ANALYTICS_DEVELOPER = 'analytics_developer'
  USERS_DATA_ANALYST = 'data_analyst'
  USERS_COLLABORATOR = 'collaborator'
  USERS_BUSINESS_USER = 'business_user'

  def initialize(lic=nil)
    unless lic
      path = (File.exists?(license_path) ? license_path : default_license_path)
      lic = HonorCodes.interpret(path)[:license].symbolize_keys
    end
    @license = lic
  end

  def self.instance
    @instance ||= License.new
  end

  def [](key)
    @license[key]
  end

  def workflow_enabled?
    alpine_or_pivotal?
  end

  def branding
    self[:vendor] == VENDOR_PIVOTAL ? VENDOR_PIVOTAL : VENDOR_ALPINE
  end

  def branding_title
    %(#{self.branding.titlecase} Chorus)
  end

  def limit_search?
    explorer?
  end

  def advisor_now_enabled?
    alpine_or_pivotal?
  end

  def limit_workspace_membership?
    explorer?
  end

  def limit_user_count?
    alpine_or_pivotal?
  end

  def limit_data_source_types?
    explorer? || basecamp?
  end

  def limit_milestones?
    self[:milestones] == false
  end

  def limit_jobs?
    self[:scheduling] == false
  end

  def home_page
    explorer? ? 'WorkspaceIndex' : nil
  end

  def limit_sandboxes?
    explorer?
  end

  def expires?
    alpine_or_pivotal?
  end

  def expired?(date=Date.current)
    expires? && self[:expires] < date
  end

  # VERSION
  # tack on the version information to the license model
  # it isnt part of the actual license file, but is made part of the license information
  def version
    build_string
  end

  # END VERSION

  private

  attr_reader :license

  def explorer?
    self[:vendor] == VENDOR_ALPINE && self[:level] == LEVEL_EXPLORER
  end

  def basecamp?
    self[:vendor] == VENDOR_ALPINE && self[:level] == LEVEL_BASECAMP
  end

  def alpine_or_pivotal?
    [VENDOR_ALPINE, VENDOR_PIVOTAL].include? self[:vendor]
  end

  def license_path
    Rails.root.join 'config', 'chorus.license'
  end

  def default_license_path
    Rails.root.join 'config', 'chorus.license.default'
  end

  def build_string
    f = File.join(Rails.root, 'version_build')
    File.exists?(f) ? File.read(f) : Chorus::VERSION::STRING
  end

end
