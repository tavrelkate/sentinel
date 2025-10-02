# frozen_string_literal: true

module Sentinel
  class Configuration
    attr_reader   :policy, :mask

    def initialize
      @policy   = nil
      @mask     = Mask.new(:full)
    end

    def policy=(value)
      case value
      when Symbol, String
        @policy = Policy.all[value.to_sym]
      when Policy
        @policy = value
      else
        raise ArgumentError, "Invalid policy: #{value.inspect}"
      end
    end

    def mask=(value)
      case value
      when Symbol, String
        @mask = Mask.new(value.to_sym)
      when Mask
        @mask = value
      else
        raise ArgumentError, "Invalid mask: #{value.inspect}"
      end
    end
  end
end
