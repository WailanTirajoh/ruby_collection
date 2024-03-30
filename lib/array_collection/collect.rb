# frozen_string_literal: true

require_relative "collection_array"
require_relative "hooks"
require_relative "json_parser"
require_relative "collect_components/filtering"
require_relative "collect_components/sorting"
require_relative "collect_components/mapping"
require_relative "collect_components/joining"
require_relative "collect_components/data_handling"
require_relative "collect_components/json_handling"
require_relative "collect_components/condition_handling"
require_relative "collect_components/key_filtering"

module ArrayCollection
  # Set of chainable collections
  class Collect
    extend ArrayCollection::Hooks
    include ArrayCollection::CollectComponents::Filtering
    include ArrayCollection::CollectComponents::Sorting
    include ArrayCollection::CollectComponents::Mapping
    include ArrayCollection::CollectComponents::Joining
    include ArrayCollection::CollectComponents::DataHandling
    include ArrayCollection::CollectComponents::JsonHandling
    include ArrayCollection::CollectComponents::ConditionHandling
    include ArrayCollection::CollectComponents::KeyFiltering

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

    # Hooks
    before :key_by, :check_hash_item
    before :only, :check_hash_item
  end
end
