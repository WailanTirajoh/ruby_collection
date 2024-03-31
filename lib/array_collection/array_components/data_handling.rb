# frozen_string_literal: true

module ArrayCollection
  module ArrayComponents
    module DataHandling # rubocop:disable Style/Documentation
      def wrap(value)
        return [] if value.nil?
        return value if value.is_a?(Array)

        [value]
      end

      def append(array, *elements)
        array + elements
      end

      def prepend(array, *elements)
        elements + array
      end

      def diff(array1, array2)
        (array1 - array2) | (array2 - array1)
      end
    end
  end
end
