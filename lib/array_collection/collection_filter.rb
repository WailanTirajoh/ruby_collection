# frozen_string_literal: true

module ArrayCollection
  class UnsupportedOperator < ArgumentError; end

  # filterable item using operators
  class CollectionFilter
    OPERATORS = {
      "=" => ->(a, b) { a == b },
      "==" => ->(a, b) { a == b },
      "!=" => ->(a, b) { a != b },
      "<>" => ->(a, b) { a != b },
      ">" => ->(a, b) { a > b },
      ">=" => ->(a, b) { a >= b },
      "<" => ->(a, b) { a < b },
      "<=" => ->(a, b) { a <= b },
      "LIKE" => ->(a, b) { a.to_s.include?(b.to_s) },
      "NOT LIKE" => ->(a, b) { !a.to_s.include?(b.to_s) }
    }.freeze

    def self.apply_operator(operator, a, b) # rubocop:disable Naming/MethodParameterName
      operator_lambda = OPERATORS[operator.upcase]
      unless operator_lambda
        raise UnsupportedOperator,
              "Unsupported operator: #{operator}, current supported operator: #{OPERATORS.keys}"
      end

      operator_lambda.call(a, b)
    end
  end
end
