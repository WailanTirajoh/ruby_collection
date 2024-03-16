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

    it "returns nil if the index is not found" do
      expect(collect([1, 2, 3, 4, 2]).index_of(5)).to be_nil
    end
  end

  describe "#key_by" do
    context "when input is an array of hashes" do
      it "transforms attributes using a block" do
        records = [
          { "badgenumber" => 123, "first_checkin" => "2024-03-01", "last_checkout" => "2024-03-02" },
          { "badgenumber" => 1, "first_checkin" => "2024-03-03", "last_checkout" => "2024-03-04" }
        ]

        result = collect(records).key_by("badgenumber") do |record|
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
        expect { collect(non_hash_input).key_by("key") { |record| record } }
          .to raise_error(ArgumentError, "Input must be an array of hashes")
      end
    end
  end

  describe "#sort" do
    it "sorts items in ascending order based on provided block" do
      items = [5, 3, 1, 4, 2]
      result = collect(items).sort { |a, b| a <=> b }.all
      expect(result).to eq([1, 2, 3, 4, 5])
    end
  end

  describe "#sort_desc" do
    it "sorts items in descending order based on provided block" do
      items = [5, 3, 1, 4, 2]
      result = collect(items).sort_desc { |a, b| a <=> b }.all
      expect(result).to eq([5, 4, 3, 2, 1])
    end
  end

  describe "#sort_by_key" do
    it "sorts items by the specified key" do
      items = [
        { a: 3, b: 1 },
        { a: 1, b: 2 },
        { a: 2, b: 3 }
      ]
      result = collect(items).sort_by_key(:a).all
      expect(result).to eq([
                             { a: 1, b: 2 },
                             { a: 2, b: 3 },
                             { a: 3, b: 1 }
                           ])
    end
  end

  describe "#append" do
    it "appends the value to the collection" do
      items = [1, 2, 3]
      result = collect(items).append(4).all
      expect(result).to eq([1, 2, 3, 4])
    end
  end

  describe "#prepend" do
    it "prepends the value to the collection" do
      items = [2, 3, 4]
      result = collect(items).prepend(1).all
      expect(result).to eq([1, 2, 3, 4])
    end
  end

  context "when it chained" do
    items = [
      { a: 3, b: 1, x: [1, 2, 3] },
      { a: 1, b: 2, x: [] },
      { a: 2, b: 3, x: [2, 3] },
      nil
    ]

    it "return correct output" do
      result = collect(items)
               .where_not_nil
               .where { |item| item[:a] > 1 }
               .append({ a: 0, b: 2 })
               .prepend({ a: 4, b: 2 })
               .sort_by_key(:a)
               .map do |item|
                 {
                   a: item[:a],
                   b: item[:b],
                   c: item[:a] + item[:b],
                   x: collect(item[:x]).sort.all
                 }
               end
               .all
      expect(result).to eq(
        [
          { a: 0, b: 2, c: 2, x: [] },
          { a: 2, b: 3, c: 5, x: [2, 3] },
          { a: 3, b: 1, c: 4, x: [1, 2, 3] },
          { a: 4, b: 2, c: 6, x: [] }
        ]
      )
    end
  end

  private

  def collect(items)
    Collection::Collect.new(items)
  end
end
