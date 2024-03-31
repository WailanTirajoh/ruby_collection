# frozen_string_literal: true

require "array_collection/collection_filter"

module ArrayCollection
  module ArrayComponents
    # Module containing methods for joining arrays
    module Joining
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

      def cross_join(array1, array2)
        return cross_join_hashes(array1, array2) if array1.all?(Hash) && array2.all?(Hash)

        array1.product(array2)
      end

      private

      def cross_join_hashes(array1, array2)
        array1.flat_map { |hash1| array2.map { |hash2| hash1.merge(hash2) } }
      end

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
