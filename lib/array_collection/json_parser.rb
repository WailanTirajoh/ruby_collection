# frozen_string_literal: true

module ArrayCollection
  # JSON Parser for collection
  class JsonParser
    class << self
      def json_like?(input)
        return false if input.nil? || input.count.zero?

        hash = input[0]
        hash.is_a?(Hash) && hash.keys.all?(String)
      end

      def parse_to_hash(json_like)
        json_like.map { |hash| deep_string_to_symbol(hash) }
      end

      def parse_to_json(hashes)
        hashes.map { |hash| deep_stringify_keys(hash) }
      end

      private

      def deep_string_to_symbol(hash)
        return hash unless hash.is_a?(Hash)

        hash.each_with_object({}) do |(key, value), result|
          new_key = key.is_a?(String) ? key.to_sym : key
          result[new_key] = deep_string_to_symbol(value)
        end
      end

      def deep_stringify_keys(hash)
        hash.each_with_object({}) do |(key, value), result|
          new_key = key.to_s
          new_value = value.is_a?(Hash) ? deep_stringify_keys(value) : value
          result[new_key] = new_value
        end
      end
    end
  end
end
