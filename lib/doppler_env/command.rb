require "json"

module DopplerEnv
  module Command
    module_function

    def secrets_download
      `doppler secrets download --no-file --format=json`
    end

    def configure
      `doppler configure --json`
    end
  end
end
