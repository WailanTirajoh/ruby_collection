# frozen_string_literal: true

module ArrayCollection
  # Internal hooks
  module Hooks
    def before(method_to_hook, before_method)
      alias_method(:"#{method_to_hook}_original", method_to_hook)
      define_method(method_to_hook) do |*args, &block|
        send(before_method)
        send(:"#{method_to_hook}_original", *args, &block)
      end
    end
  end
end
