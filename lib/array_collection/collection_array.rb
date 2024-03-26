# frozen_string_literal: true

require_relative "collection_filter"

module ArrayCollection
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
          array.select { |item| ArrayCollection::CollectionFilter.apply_operator(operator, item[key], value) }
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

      def join(array1, array2, key1, key2)
        inner_join(array1, array2, key1, key2)
      end

      def inner_join(array1, array2, key1, key2)
        array1.reject do |item1|
          matching_items = array2.select { |item2| item1[key1] == item2[key2] }
          matching_items.each { |matched_item| item1.merge!(matched_item) }
          matching_items.empty?
        end
      end

      def left_join(array1, array2, key1, key2)
        return array1 if array2.count.zero?

        right_index = build_index(array2, key2)

        result = []
        array1.each do |left_item|
          right_items = right_index[left_item[key1]] || [nil_attributes(array2)]
          merge_items(result, left_item, right_items)
        end
        result
      end

      def right_join(array1, array2, key1, key2)
        left_index = build_index(array1, key1)

        result = []
        array2.each do |right_item|
          left_items = left_index[right_item[key2]] || [nil_attributes(array1)]
          merge_items(result, right_item, left_items)
        end
        result
      end

      def full_join(array1, array2, key1, key2)
        left_join_result = left_join(array1, array2, key1, key2)
        right_join_result = right_join(array1, array2, key1, key2)

        left_join_result.concat(right_join_result).uniq
      end

      def full_outter_join(array1, array2, key1, key2)
        full_join(array1, array2, key1, key2)
      end

      private

      def build_index(array, key)
        array.group_by { |item| item[key] }
      end

      def merge_items(result, left_item, right_items)
        right_items.each do |right_item|
          result << left_item.merge(right_item)
        end
      end

      def nil_attributes(array)
        array.first.keys.each_with_object({}) { |key, hash| hash[key] = nil }
      end
    end
  end
end
