# frozen_string_literal: true

require_relative "collection_array"
require_relative "hooks"
require_relative "json_parser"

module ArrayCollection
  # Set of chainable collections
  class Collect # rubocop:disable Metrics/ClassLength
    extend ArrayCollection::Hooks

    def initialize(items)
      parsed_hash = parse(items)
      @items, @is_json = get_arrayable_items(parsed_hash)
    end

    def all
      parse_output(@items)
    end

    def count(&block)
      @items.count(&block)
    end

    def index_of(value)
      @items.index(value)
    end

    def key_by(key, &block)
      ArrayCollection::CollectionArray.key_by(@items, key.to_sym, &block)
    end

    def when(boolean)
      return self if boolean == false

      yield(self)
    end

    def unless(boolean)
      return self if boolean == true

      yield(self)
    end

    def append(value)
      clone(ArrayCollection::CollectionArray.append(@items, value))
    end

    def prepend(value)
      clone(ArrayCollection::CollectionArray.prepend(@items, value))
    end

    def diff(items)
      clone(ArrayCollection::CollectionArray.diff(@items, items))
    end

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

    def only(*keys)
      clone(ArrayCollection::CollectionArray.only(@items, *keys.map(&:to_sym)))
    end

    def except(*keys)
      clone(ArrayCollection::CollectionArray.except(@items, *keys.map(&:to_sym)))
    end

    def map(&block)
      clone(ArrayCollection::CollectionArray.map(@items, &block))
    end

    def sort(&block)
      clone(@items.sort(&block))
    end

    def sort_desc(&block)
      clone(@items.sort(&block).reverse)
    end

    def sort_by_key(key)
      clone(@items.sort_by { |item| item[key.to_sym] })
    end

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

    private

    def clone(result)
      self.class.new(parse_output(result))
    end

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
      raise ArgumentError, "Input must be an array of hashes" unless @items.all?(Hash)
    end

    def json?
      @is_json
    end

    def parse(items)
      is_json = ArrayCollection::JsonParser.json_like?(items)
      result = is_json ? ArrayCollection::JsonParser.parse_to_hash(items) : items

      [get_arrayable_items(result), is_json]
    end

    def parse_output(items)
      if json?
        ArrayCollection::JsonParser.parse_to_json(items)
      else
        items
      end
    end

    # Hooks
    before :key_by, :check_hash_item
    before :only, :check_hash_item
  end
end
