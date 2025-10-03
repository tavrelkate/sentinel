# frozen_string_literal: true

module Sentinel
  class Data
    Adapter = ->(klass) do
      if klass <= Exception
        Sentinel::Adapters::Exception
      else
        Sentinel::Adapters.const_get(klass.name)
      end
    end

    def self.new(raw_data)
      instance = allocate
      instance.send(:initialize, raw_data)
      instance.send(:scrubbed)
    end

    private

    def initialize(raw_data)
      @raw_data = raw_data
    end

    def scrubbed
      Adapter.(@raw_data.class).new(@raw_data).result
    rescue NameError
      Warning.warn "[Sentinel] unsupportable data type: #{@raw_data.class}\n"
      @raw_data
    rescue => e
      Warning.warn "[Sentinel] scrub error: #{e.message}\n"
      @raw_data
    end
  end
end
