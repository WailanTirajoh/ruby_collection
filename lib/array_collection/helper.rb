# frozen_string_literal: true

require_relative "collect"

module ArrayCollection
  # Expose collect
  module Helper
    module_function

    def collect(values)
      ArrayCollection::Collect.new(values)
    end
  end
end
