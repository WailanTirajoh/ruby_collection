# frozen_string_literal: true

module ArrayCollection
  module CollectComponents
    # JSON Array handlers
    module JsonHandling
      def json?
        @is_json
      end

      # Json parser input, takes array key of string or key of symbol and returns key of symbol
      #
      # @param [Array] items
      # @return [Array]
      def parse(items)
        is_json = ArrayCollection::JsonParser.json_like?(items)
        result = is_json ? ArrayCollection::JsonParser.parse_to_hash(items) : items

        [get_arrayable_items(result), is_json]
      end

      # Json parser output, check whenever input key is symbol / string, it will return the same result.
      #
      # @param [Array] items
      # @return [Array]
      def parse_output(items)
        if json?
          ArrayCollection::JsonParser.parse_to_json(items)
        else
          items
        end
      end
    end
  end
end
