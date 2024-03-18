# frozen_string_literal: true

require "spec_helper"

RSpec.describe Collection::CollectionFilter do
  describe ".apply_operator" do
    context "when given a valid operator" do
      it "applies the equality operator correctly" do
        expect(described_class.apply_operator("=", 10, 10)).to be_truthy
      end

      it "applies the equality operator correctly using ==" do
        expect(described_class.apply_operator("==", 2, 2)).to be_truthy
      end

      it "applies the inequality operator correctly" do
        expect(described_class.apply_operator("!=", 10, 5)).to be_truthy
      end

      it "applies the inequality operator correctly using <>" do
        expect(described_class.apply_operator("<>", 2, 3)).to be_truthy
      end

      it "applies the greater than operator correctly" do
        expect(described_class.apply_operator(">", 10, 5)).to be_truthy
      end

      it "applies the greater than or equal to operator correctly" do
        expect(described_class.apply_operator(">=", 10, 10)).to be_truthy
      end

      it "applies the less than operator correctly" do
        expect(described_class.apply_operator("<", 5, 10)).to be_truthy
      end

      it "applies the less than or equal to operator correctly" do
        expect(described_class.apply_operator("<=", 10, 10)).to be_truthy
      end

      it "applies the LIKE operator correctly" do
        expect(described_class.apply_operator("LIKE", "hello", "ell")).to be_truthy
      end

      it "applies the NOT LIKE operator correctly" do
        expect(described_class.apply_operator("NOT LIKE", "hello", "world")).to be_truthy
      end
    end

    context "when given an invalid operator" do
      it "raises an ArgumentError" do
        expect { described_class.apply_operator("~", 10, 10) }
          .to raise_error(ArgumentError, /Unsupported operator/)
      end
    end
  end
end
