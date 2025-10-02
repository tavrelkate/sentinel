# frozen_string_literal: true

require_relative "sentinel/version"


require_relative "sentinel/core/configuration"
require_relative "sentinel/core/policy"
require_relative "sentinel/core/mask"
require_relative "sentinel/core/data"

require_relative "sentinel/adapters/hash"
require_relative "sentinel/adapters/array"
require_relative "sentinel/adapters/exception"
require_relative "sentinel/adapters/string"

require_relative "sentinel/extensions/patterns"
require_relative "sentinel/extensions/policies"



module Sentinel
  class << self
    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||=Configuration.new
    end

    def policies
      Policy.all
    end

    def mask_modes
      Mask.available_modes
    end

    def scrub(data)
      Data.new(data)
    end
  end
end
