# frozen_string_literal: true

module ArrayCollection
  module CollectComponents
    # Array key filters
    module KeyFiltering
      def only(*keys)
        clone(ArrayCollection::CollectionArray.only(@items, *keys.map(&:to_sym)))
      end

      def except(*keys)
        clone(ArrayCollection::CollectionArray.except(@items, *keys.map(&:to_sym)))
      end
    end
  end
end
