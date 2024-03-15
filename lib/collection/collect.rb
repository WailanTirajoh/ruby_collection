# frozen_string_literal: true

module Collection
  # Set of chainable collections
  class Collect
    def initialize(items)
      @items = get_arrayable_items(items)
    end

    def all
      @items
    end

    def where(&block)
      @items = Collection::CollectionArray.where(@items, &block)
      self
    end

    def where_not_nil
      @items = Collection::CollectionArray.where_not_nil(@items)
      self
    end

    def index_of(value)
      @items.index(value)
    end

    def key_by(key, &block)
      raise ArgumentError, "Input must be an array of hashes" unless @items.all? { |item| item.is_a?(Hash) }

      Collection::CollectionArray.key_by(@items, key, &block)
    end

    private

    def get_arrayable_items(items)
      return items if items.is_a?(Array)

      items.to_a
    end
  end
end
