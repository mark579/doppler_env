# frozen_string_literal: true

require_relative "doppler_env/version"
require_relative "doppler_env/secret"
require_relative "doppler_env/rails"

module DopplerEnv
  class Error < StandardError; end
  class << self
    attr_accessor :instrumenter
  end

  module_function

  def load
    secrets = DopplerEnv::Secret.download
    apply(secrets)
  end

  # Takes secrets from doppler and applies to the current ENV
  # will not override existing keys
  def apply(secrets)
    secrets.each do |k, v|
      ENV[k] ||= v
    end
  end
end
