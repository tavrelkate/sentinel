require_relative "../core/base_adapter"


module Sentinel
  module Adapters
    class Array < Sentinel::BaseAdapter
      private

      def clean
        data.map! { |v| Sentinel::Data.new(v) }
      end
    end
  end
end
