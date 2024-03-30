# frozen_string_literal: true

module ArrayCollection
  module CollectComponents
    # Array conditional hanling
    module ConditionHandling
      def when(boolean)
        return self if boolean == false

        yield(self)
      end
    end
  end
end
