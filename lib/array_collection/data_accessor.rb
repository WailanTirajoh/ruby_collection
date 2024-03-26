# frozen_string_literal: true

module ArrayCollection
  # Data retreiver based on string dot notation
  class DataAccessor
    class << self
      # TODO: Refactor
      def get(target, key, default = nil) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
        return target if key.nil?

        key = key.split(".") unless key.is_a?(Array)

        key.each_with_index do |segment, i|
          return target if segment.nil?

          if segment == "*"
            return default unless target.is_a?(Array)

            result = target.map { |item| get(item, key[i + 1..]) }
            return key.include?("*") ? result.flatten : result
          end

          segment = if segment.to_i.to_s == segment
                      segment.to_i
                    else
                      segment.to_sym
                    end
          if target.respond_to?(:[]) && target[segment]
            target = target[segment]
          elsif target.respond_to?(segment)
            target = target.send(segment)
          else
            return default
          end
        end

        target
      end
    end
  end
end
