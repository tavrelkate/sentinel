require_relative "../core/base_adapter"

require "json"

module Sentinel
  module Adapters
    class String < Sentinel::BaseAdapter
      private

      def clean
        filtered = scrub_as_json || scrub_as_query || data.dup
        scrub_with_patterns(filtered)
      end

      def scrub_as_json
        obj = JSON.parse(data) rescue nil
        return unless obj.is_a?(::Hash)

        policy.keywords.each do |kw|
          obj.each do |k, v|
            if k.to_s.include?(kw)
              obj[k] = mask.hide(v.to_s)
            end
          end
        end

        obj.to_json
      end

      def scrub_as_query
        return unless data.include?("=") && data.include?("&")

        data.split("&").map do |pair|
          key, value = pair.split("=", 2)
          if policy.keywords.any? { |kw| key.include?(kw) }
            "#{key}=#{mask.hide(value)}"
          else
            pair
          end
        end.join("&")
      end

      def scrub_with_patterns(str)
        policy.regexes.each do |rgx|
          str.gsub!(rgx) { |m| mask.hide(m) }
        end
        str
      end
    end
  end
end
