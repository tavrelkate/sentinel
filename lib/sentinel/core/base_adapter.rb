require "forwardable"

module Sentinel
  class BaseAdapter
    extend Forwardable
    attr_reader :result

    def_delegators "Sentinel.configuration", :policy, :mask

    def initialize(raw_data)
      @data   = raw_data
      @result = clean
    end

    private

    attr_reader :data
  end
end
