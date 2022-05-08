require "json"
require "doppler_env/command"

module DopplerEnv
  module Secret
    class NotConfigured < StandardError; end
    module_function

    def download
      raise NotConfigured unless configured?
      JSON.parse(DopplerEnv::Command.secrets_download)
    end

    def configured?
      config = JSON.parse(DopplerEnv::Command.configure)
      return true if config.keys.reject { |k| k == "/" }
      false
    end
  end
end
