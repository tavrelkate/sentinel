# lib/sentinel/plugins/rails/log_formatter.rb
require "logger"
require "json"

module Sentinel
  module Plugins
    module Rails
      class LogFormatter < ::Logger::Formatter
        def call(severity, time, progname, msg)
          masked = ::Sentinel::Data.new(msg)
          super(severity, time, progname, masked)
        rescue => e
          super(severity, time, progname, "[Sentinel error: #{e.class}] #{msg.inspect}")
        end
      end
    end
  end
end
