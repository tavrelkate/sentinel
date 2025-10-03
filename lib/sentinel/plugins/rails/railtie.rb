# lib/sentinel/plugins/rails/railtie.rb
# frozen_string_literal: true
require "rails/railtie"
require "active_support/logger"
require_relative "log_formatter"

module Sentinel
  module Plugins
    module Rails
      class Railtie < ::Rails::Railtie
        config.sentinel = ActiveSupport::OrderedOptions.new unless config.respond_to?(:sentinel)
        config.sentinel.enable_log_formatter = false

        initializer "sentinel.log_formatter", after: :initialize_logger do |app|
          next unless app.config.sentinel.enable_log_formatter
          formatter = ::Sentinel::Plugins::Rails::LogFormatter.new
          base = ::Rails.logger.respond_to?(:logger) ? ::Rails.logger.logger : ::Rails.logger
          base ||= ActiveSupport::Logger.new($stdout)
          base.formatter = formatter
          wrapped = base.is_a?(ActiveSupport::TaggedLogging) ? base : ActiveSupport::TaggedLogging.new(base)
          ::Rails.logger = wrapped
          app.config.logger = wrapped
          app.config.log_formatter = formatter
          ActiveSupport::LogSubscriber.logger = ::Rails.logger
        end
      end
    end
  end
end
