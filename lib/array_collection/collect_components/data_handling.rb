# frozen_string_literal: true

module ArrayCollection
  module CollectComponents
    # Array manipulation
    module DataHandling
      def append(value)
        clone(ArrayCollection::CollectionArray.append(@items, value))
      end

      def prepend(value)
        clone(ArrayCollection::CollectionArray.prepend(@items, value))
      end

      def diff(items)
        clone(ArrayCollection::CollectionArray.diff(@items, items))
      end
    end
  end
end
