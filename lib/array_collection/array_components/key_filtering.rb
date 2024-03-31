# frozen_string_literal: true

module ArrayCollection
  module ArrayComponents
    module KeyFiltering # rubocop:disable Style/Documentation
      def key_by(records, key)
        records.to_h { |record| [record[key].to_s, yield(record)] }
      end

      def except(array, *keys)
        raise ArgumentError, "Empty key list" if keys.empty?

        array.map { |hash| hash.except(*keys) }
      end

      def only(array, *keys)
        raise ArgumentError, "Empty key list" if keys.empty?

        array.map { |hash| hash.select { |k, _| keys.include?(k) } }
      end
    end
  end
end
