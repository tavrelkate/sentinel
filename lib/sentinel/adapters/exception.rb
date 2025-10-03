require_relative "../core/base_adapter"

module Sentinel
  module Adapters
    class Exception < Sentinel::BaseAdapter
      private

      def clean
        scrubbed = Sentinel::Data.new(data.message)

        new_exc = data.class.new(scrubbed.to_s)
        new_exc.set_backtrace(data.backtrace)
        new_exc
      end
    end
  end
end
