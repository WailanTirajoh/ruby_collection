# frozen_string_literal: true

require_relative "collection_array"

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
      self.class.new(Collection::CollectionArray.where(@items, &block))
    end

    def where_not_nil
      self.class.new(Collection::CollectionArray.where_not_nil(@items))
    end

    def index_of(value)
      @items.index(value)
    end

    def key_by(key, &block)
      raise ArgumentError, "Input must be an array of hashes" unless @items.all? { |item| item.is_a?(Hash) }

      Collection::CollectionArray.key_by(@items, key, &block)
    end

    def sort(&block)
      self.class.new(@items.sort(&block))
    end

    def sort_desc(&block)
      self.class.new(@items.sort(&block).reverse)
    end

    def sort_by_key(key)
      self.class.new(@items.sort_by { |item| item[key] })
    end

    def append(value)
      self.class.new(Collection::CollectionArray.append(@items, value))
    end

    def prepend(value)
      self.class.new(Collection::CollectionArray.prepend(@items, value))
    end

    def map(&block)
      self.class.new(Collection::CollectionArray.map(@items, &block))
    end

    private

    def get_arrayable_items(items)
      return items if items.is_a?(Array)

      items.to_a
    end
  end
end
