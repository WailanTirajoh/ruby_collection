# frozen_string_literal: true

require_relative "collection_filter"

module Collection
  # Sets of array utilities methods
  class CollectionArray
    class << self
      def filter(array, &block)
        array.select(&block)
      end

      def where(array, *args)
        if args.size == 2
          key, value = args
          array.select { |item| item[key] == value }
        elsif args.size == 3
          key, operator, value = args
          array.select { |item| Collection::CollectionFilter.apply_operator(operator, item[key], value) }
        else
          raise ArgumentError, "Invalid number of arguments"
        end
      end

      def where_not_nil(array)
        array.compact
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

      def except(array, *keys)
        raise ArgumentError, "Empty key list" if keys.empty?

        array.map { |hash| hash.except(*keys) }
      end

      def only(array, *keys)
        raise ArgumentError, "Empty key list" if keys.empty?

        array.map { |hash| hash.select { |k, _| keys.include?(k) } }
      end

      def diff(array1, array2)
        (array1 - array2) | (array2 - array1)
      end
    end
  end
end
