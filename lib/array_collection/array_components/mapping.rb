# frozen_string_literal: true

module ArrayCollection
  module ArrayComponents
    module Mapping # rubocop:disable Style/Documentation
      def map(array, &block)
        array.map(&block)
      end

      def map_with_keys(hash, &block)
        hash.transform_values(&block)
      end
    end
  end
end
