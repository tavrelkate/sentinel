require_relative "../core/base_adapter"


module Sentinel
  module Adapters
    class Hash < Sentinel::BaseAdapter
      private

      def clean
        scrubbed = data.dup
        policy.keywords.each do |kw|
          scrubbed.keys.each do |k|
            if k.to_s.include?(kw)
              scrubbed[k] = mask.hide(scrubbed[k].to_s)
            end
          end
        end

        scrubbed.transform_values! { |v| Data.new(v) }
        scrubbed
      end
    end
  end
end
