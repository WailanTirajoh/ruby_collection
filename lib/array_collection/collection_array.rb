# frozen_string_literal: true

require_relative "array_components/filtering"
require_relative "array_components/mapping"
require_relative "array_components/data_handling"
require_relative "array_components/key_filtering"
require_relative "array_components/joining"

module ArrayCollection
  # Sets of array utilities methods
  class CollectionArray
    class << self
      include ArrayCollection::ArrayComponents::Filtering
      include ArrayCollection::ArrayComponents::Mapping
      include ArrayCollection::ArrayComponents::DataHandling
      include ArrayCollection::ArrayComponents::KeyFiltering
      include ArrayCollection::ArrayComponents::Joining
    end
  end
end
