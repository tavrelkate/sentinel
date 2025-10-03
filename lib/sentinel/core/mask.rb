# frozen_string_literal: true

require "digest"

module Sentinel
  class Mask
    MODES = %i[full partial hash].freeze
    DEFAULT_PLACEHOLDER = "[FILTERED]".freeze

    def self.available_modes
      MODES
    end

    attr_reader :mode, :placeholder

    def initialize(mode = :full, placeholder = DEFAULT_PLACEHOLDER)
      unless MODES.include?(mode)
        raise ArgumentError, "invalid mode: #{mode.inspect}"
      end

      @mode     = mode
      @placeholder = placeholder
    end

    def hide(value)
      case mode
      when :full
        placeholder
      when :partial
        partial_hide(value)
      when :hash
        Digest::SHA256.hexdigest(value.to_s)
      end
    end

    alias apply hide

    private

    def partial_hide(value)
      return placeholder if value.empty?

      "#{value[0, 2]}#{placeholder}#{value[-2, 2]}"
    end
  end
end
