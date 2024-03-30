# frozen_string_literal: true

module ArrayCollection
  module CollectComponents
    # Array filters
    module Filtering
      def filter(&block)
        clone(ArrayCollection::CollectionArray.filter(@items, &block))
      end

      def where(key, *args)
        clone(ArrayCollection::CollectionArray.where(@items, key, *args))
      end

      def where_not_nil
        clone(ArrayCollection::CollectionArray.where_not_nil(@items))
      end

      def uniq
        clone(@items.uniq)
      end
    end
  end
end
