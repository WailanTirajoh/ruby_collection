# frozen_string_literal: true

module ArrayCollection
  module CollectComponents
    # Array mapping
    module Mapping
      def map(&block)
        clone(ArrayCollection::CollectionArray.map(@items, &block))
      end
    end
  end
end
