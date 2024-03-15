# frozen_string_literal: true

require "spec_helper"

RSpec.describe Collection::Collect do
  describe "#all" do
    it "returns all items" do
      items = [1, 2, 3]
      expect(collect(items).all).to eq(items)
    end
  end

  describe "#where" do
    it "filters items based on the given block" do
      items = [1, 2, 3, 4, 5]
      result = collect(items)
               .where { |item| item > 2 }
               .where { |item| item < 5 }
               .all
      expect(result).to eq([3, 4])
    end
  end

  describe "#where_not_nil" do
    it "filters nil items based on the given block" do
      items = [1, 2, nil, 3, 4, nil, 5]
      result = collect(items)
               .where_not_nil
               .all
      expect(result).to eq([1, 2, 3, 4, 5])
    end
  end

  describe "#index_of" do
    it "returns the index of the first occurrence of the given value" do
      expect(collect([1, 2, 3, 4, 2]).index_of(2)).to eq(1)
    end
  end

  describe "#key_by" do
    context "when input is an array of hashes" do
      it "transforms attributes using a block" do
        records = [
          { "badgenumber" => 123, "first_checkin" => "2024-03-01", "last_checkout" => "2024-03-02" },
          { "badgenumber" => 1, "first_checkin" => "2024-03-03", "last_checkout" => "2024-03-04" }
        ]

        result = Collection::Collect.new(records).key_by("badgenumber") do |record|
          {
            "first_checkin" => record["first_checkin"],
            "last_checkout" => record["last_checkout"]
          }
        end

        expected_result = {
          "123" => { "first_checkin" => "2024-03-01", "last_checkout" => "2024-03-02" },
          "1" => { "first_checkin" => "2024-03-03", "last_checkout" => "2024-03-04" }
        }
        expect(result).to eq(expected_result)
      end
    end

    context "when input is not an array of hashes" do
      it "raises an ArgumentError" do
        non_hash_input = [1, 2, 3]
        expect { Collection::Collect.new(non_hash_input).key_by("key") { |record| record } }
          .to raise_error(ArgumentError, "Input must be an array of hashes")
      end
    end
  end

  private

  def collect(items)
    Collection::Collect.new(items)
  end
end
