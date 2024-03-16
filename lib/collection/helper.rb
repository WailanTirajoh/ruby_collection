# frozen_string_literal: true

require_relative "collect"

module Collection
  # Expose collect
  module Helper
    module_function

    def collect(values)
      Collection::Collect.new(values)
    end
  end
end
