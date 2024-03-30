# frozen_string_literal: true

module ArrayCollection
  module CollectComponents
    # Array sorts
    module Sorting
      def sort(&block)
        clone(@items.sort(&block))
      end

      def sort_desc(&block)
        clone(@items.sort(&block).reverse)
      end

      def sort_by_key(key)
        clone(@items.sort_by { |item| item[key.to_sym] })
      end
    end
  end
end
