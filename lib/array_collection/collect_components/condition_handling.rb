# frozen_string_literal: true

module ArrayCollection
  module CollectComponents
    # Array conditional hanling
    module ConditionHandling
      def when(boolean)
        return self if boolean == false

        yield(self)
      end

      def unless(boolean)
        return self if boolean == true

        yield(self)
      end
    end
  end
end
