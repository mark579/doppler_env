require "doppler_env"

if defined?(Rake.application)
  task_regular_expression = /^(default$|parallel:spec|spec(:|$))/
  if Rake.application.top_level_tasks.grep(task_regular_expression).any?
    environment = Rake.application.options.show_tasks ? "development" : "test"
    Rails.env = ENV["RAILS_ENV"] ||= environment
  end
end

# DopplerEnv.instrumenter = ActiveSupport::Notifications

begin
  require "spring/commands"
  ActiveSupport::Notifications.subscribe(/^doppler_env/) do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    Spring.watch event.payload[:env].filename if Rails.application
  end
rescue LoadError, ArgumentError
  # Spring is not available
end

module DopplerEnv
  class Railtie < Rails::Railtie
    def load
      DopplerEnv.load
    end

    def self.load
      instance.load
    end

    config.before_configuration { load }
  end
end
