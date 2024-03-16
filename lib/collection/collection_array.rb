# frozen_string_literal: true

require "debug"

module Collection
  # Sets of array utilities methods
  class CollectionArray
    class << self
      def where(array, &block)
        array.select(&block)
      end

      def where_not_nil(array)
        where(array) { |value| !value.nil? }
      end

      def wrap(value)
        return [] if value.nil?
        return value if value.is_a?(Array)

        [value]
      end

      def append(array, *elements)
        array + elements
      end

      def prepend(array, *elements)
        elements + array
      end

      def map(array, &block)
        array.map(&block)
      end

      def map_with_keys(hash, &block)
        hash.transform_values(&block)
      end

      def key_by(records, key)
        records.to_h { |record| [record[key].to_s, yield(record)] }
      end
    end
  end
end
