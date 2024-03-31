# frozen_string_literal: true

module ArrayCollection
  module ArrayComponents
    module Filtering # rubocop:disable Style/Documentation
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
    end
  end
end
