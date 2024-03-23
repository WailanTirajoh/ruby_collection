# frozen_string_literal: true

require "spec_helper"

RSpec.describe Collection::DataAccessor do
  describe ".get" do
    let(:data) do
      {
        user: {
          name: "John",
          email: "john@example.com",
          address: {
            city: "New York",
            zip_code: "10001"
          },
          orders: [
            { id: 1, total: 100 },
            { id: 2, total: 150 }
          ]
        }
      }
    end

    context "with existing keys" do
      it "gets value of a single key" do
        expect(described_class.get(data, "user.name")).to eq("John")
      end

      it "gets value of nested keys" do
        expect(described_class.get(data, "user.address.city")).to eq("New York")
      end

      it "gets value of array elements" do
        expect(described_class.get(data, "user.orders.1.total")).to eq(150)
      end

      it "gets value of array elements with wildcard" do
        expect(described_class.get(data, "user.orders.*.id")).to eq([1, 2])
      end
    end

    context "with non-existing keys" do
      it "returns default value" do
        expect(described_class.get(data, "user.age", "N/A")).to eq("N/A")
      end
    end

    context "with nil key" do
      it "returns target data" do
        expect(described_class.get(data, nil)).to eq(data)
      end
    end

    context "with nil target" do
      it "returns nil" do
        expect(described_class.get(nil, "user.name")).to be_nil
      end
    end

    context "when the target responds to each" do
      it "returns an array of values" do
        target = [{ name: "Alice" }, { name: "Bob" }]
        expect(described_class.get(target, "*.name")).to eq(%w[Alice Bob])
      end
    end

    context "when the target responds to the segment" do
      it "returns the target's value" do
        target = { user: Object.new }
        expect(described_class.get(target, "user.to_s")).to eq(target[:user].to_s)
      end
    end
  end
end
