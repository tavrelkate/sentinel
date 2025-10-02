# frozen_string_literal: true

require "digest"

module Sentinel
  class Mask
    MODES = %i[full partial hash].freeze
    DEFAULT_PATTERN = "[FILTERED]".freeze

    def self.available_modes
      MODES
    end

    attr_reader :mode, :pattern

    def initialize(mode = :full, pattern = DEFAULT_PATTERN)
      unless MODES.include?(mode)
        raise ArgumentError, "Invalid mode: #{mode.inspect}"
      end

      @mode     = mode
      @pattern = pattern
    end

    def hide(value)
      case mode
      when :full
        pattern
      when :partial
        partial_hide(value)
      when :hash
        Digest::SHA256.hexdigest(value.to_s)
      end
    end

    alias apply hide

    private

    def partial_hide(value)
      return pattern if value.empty?

      "#{value[0, 2]}#{pattern}#{value[-2, 2]}"
    end
  end
end
