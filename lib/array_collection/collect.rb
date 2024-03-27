# frozen_string_literal: true

require_relative "collection_array"
require_relative "hooks"

module ArrayCollection
  # Set of chainable collections
  class Collect
    extend ArrayCollection::Hooks

    def initialize(items)
      @items = get_arrayable_items(items)
    end

    def all
      @items
    end

    def count
      @items.count
    end

    def filter(&block)
      self.class.new(ArrayCollection::CollectionArray.filter(@items, &block))
    end

    def where(key, *args)
      self.class.new(ArrayCollection::CollectionArray.where(@items, key, *args))
    end

    def where_not_nil
      self.class.new(ArrayCollection::CollectionArray.where_not_nil(@items))
    end

    def index_of(value)
      @items.index(value)
    end

    def key_by(key, &block)
      ArrayCollection::CollectionArray.key_by(@items, key, &block)
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
      self.class.new(ArrayCollection::CollectionArray.append(@items, value))
    end

    def prepend(value)
      self.class.new(ArrayCollection::CollectionArray.prepend(@items, value))
    end

    def map(&block)
      self.class.new(ArrayCollection::CollectionArray.map(@items, &block))
    end

    def when(boolean)
      return self if boolean == false

      yield(self)
    end

    def only(*keys)
      self.class.new(ArrayCollection::CollectionArray.only(@items, *keys))
    end

    def except(*keys)
      self.class.new(ArrayCollection::CollectionArray.except(@items, *keys))
    end

    def diff(items)
      self.class.new(ArrayCollection::CollectionArray.diff(@items, items))
    end

    def inner_join(items, left_key, right_key)
      self.class.new(ArrayCollection::CollectionArray.inner_join(@items, get_arrayable_items(items), left_key,
                                                                 right_key))
    end

    def left_join(items, left_key, right_key)
      self.class.new(ArrayCollection::CollectionArray.left_join(@items, get_arrayable_items(items), left_key,
                                                                right_key))
    end

    def right_join(items, left_key, right_key)
      self.class.new(ArrayCollection::CollectionArray.right_join(@items, get_arrayable_items(items), left_key,
                                                                 right_key))
    end

    def full_join(items, left_key, right_key)
      self.class.new(ArrayCollection::CollectionArray.full_join(@items, get_arrayable_items(items), left_key,
                                                                right_key))
    end

    private

    def get_arrayable_items(items)
      case items
      when Array
        items
      when ArrayCollection::Collect
        items.all
      else
        items.to_a
      end
    end

    def check_hash_item
      raise ArgumentError, "Input must be an array of hashes" unless @items.all? { |item| item.is_a?(Hash) }
    end

    # Hooks
    before :key_by, :check_hash_item
    before :only, :check_hash_item
  end
end
