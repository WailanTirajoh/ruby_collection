# frozen_string_literal: true

module ArrayCollection
  module CollectComponents
    # SQLish join for arrays
    module Joining
      def inner_join(items, left_key, right_key)
        clone(ArrayCollection::CollectionArray.inner_join(@items, get_arrayable_items(items), left_key, right_key))
      end

      def left_join(items, left_key, right_key)
        clone(ArrayCollection::CollectionArray.left_join(@items, get_arrayable_items(items), left_key, right_key))
      end

      def right_join(items, left_key, right_key)
        clone(ArrayCollection::CollectionArray.right_join(@items, get_arrayable_items(items), left_key, right_key))
      end

      def full_join(items, left_key, right_key)
        clone(ArrayCollection::CollectionArray.full_join(@items, get_arrayable_items(items), left_key, right_key))
      end
    end
  end
end
