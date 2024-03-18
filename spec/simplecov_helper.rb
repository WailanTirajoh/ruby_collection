# frozen_string_literal: true

require "simplecov"

SimpleCov.minimum_coverage line: 100
SimpleCov.start do
  add_filter "spec/"
end
