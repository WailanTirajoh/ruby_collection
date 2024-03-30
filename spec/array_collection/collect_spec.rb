# frozen_string_literal: true

require "spec_helper"

RSpec.describe ArrayCollection::Collect do
  include ArrayCollection::Helper

  describe "#all" do
    it "returns all items" do
      items = [1, 2, 3]
      expect(collect(items).all).to eq(items)
    end
  end

  describe "#count" do
    context "when using an array" do
      let(:items) { [0, 1, 2, 3, 4] }

      it "returns the number of items" do
        expect(collect(items).count).to eq(5)
      end
    end

    context "when using an array of hashes" do
      let(:items) { [{ name: "John", age: 30 }, { name: "Jane", age: 25 }] }

      it "returns the count of items matching the block condition" do
        expect(collect(items).count { |item| item[:age] > 28 }).to eq(1)
      end
    end
  end

  describe "#uniq" do
    it "returns the unique value of items" do
      items = [0, 0, 1, 2, 2, 3, 4, 2]
      expect(collect(items).uniq.all).to eq([0, 1, 2, 3, 4])
    end
  end

  describe "#filter" do
    it "filters items based on the given block" do
      items = [1, 2, 3, 4, 5]
      result = collect(items)
               .filter { |item| item > 2 }
               .filter { |item| item < 5 }
               .all
      expect(result).to eq([3, 4])
    end
  end

  describe "#where" do
    context "when input is 2 arguments" do
      it "filters items based on the equality" do
        items = [
          { a: 3, b: 1 },
          { a: 1, b: 2 },
          { a: 2, b: 3 }
        ]
        result = collect(items).where(:a, 3).all
        expect(result).to eq([{ a: 3, b: 1 }])
      end
    end

    context "when input is 3 arguments" do
      it "filters items based on the equality" do
        items = [
          { a: 3, b: 1 },
          { a: 1, b: 2 },
          { a: 2, b: 3 }
        ]
        result = collect(items).where(:a, "!=", 3).all
        expect(result).to eq(
          [
            { a: 1, b: 2 },
            { a: 2, b: 3 }
          ]
        )
      end
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
            "first_checkin" => record[:first_checkin],
            "last_checkout" => record[:last_checkout]
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
      result = collect(items).sort.all
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
      expect(result).to eq(
        [
          { a: 1, b: 2 },
          { a: 2, b: 3 },
          { a: 3, b: 1 }
        ]
      )
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

  describe "#when" do
    context "when the condition is true" do
      it "yields to the block" do
        items = [1, 2, 3, 4, 5]
        result = collect(items).when(true) do |collection|
          collection.filter { |item| item > 2 }
        end
        expect(result.all).to eq([3, 4, 5])
      end
    end

    context "when the condition is false" do
      it "does not yield to the block" do
        items = [1, 2, 3, 4, 5]
        result = collect(items).when(false) do |collection|
          collection.filter { |item| item > 2 }
        end
        expect(result.all).to eq([1, 2, 3, 4, 5])
      end
    end
  end

  describe "#only" do
    it "returns a new collection with items containing only specified keys" do
      items = [
        { name: "Alice", age: 30, city: "New York" },
        { name: "Bob", age: 25, city: "Los Angeles" }
      ]
      result = collect(items).only(:name, :age).all

      expect(result).to eq(
        [
          { name: "Alice", age: 30 },
          { name: "Bob", age: 25 }
        ]
      )
    end
  end

  describe "#except" do
    it "returns a new collection with items excluding specified keys" do
      items = [
        { name: "Alice", age: 30, city: "New York" },
        { name: "Bob", age: 25, city: "Los Angeles" }
      ]
      result = collect(items).except(:city).all

      expect(result).to eq(
        [
          { name: "Alice", age: 30 },
          { name: "Bob", age: 25 }
        ]
      )
    end
  end

  describe "#diff" do
    context "when comparing two arrays" do
      it "returns the difference between the two arrays" do
        items1 = [1, 2, 3, 4, 5]
        items2 = [3, 4, 5, 6, 7]
        result = collect(items1).diff(items2).all
        expect(result).to eq([1, 2, 6, 7])
      end
    end
  end

  describe "#inner_join" do
    let(:left_items) do
      [
        { id: 1, name: "Alice" },
        { id: 2, name: "Bob" }
      ]
    end
    let(:right_items) do
      [
        { id: 2, age: 30 },
        { id: 3, age: 25 }
      ]
    end

    it "returns the inner join of two arrays based on the specified keys" do
      result = collect(left_items).inner_join(right_items, :id, :id).all
      expect(result).to contain_exactly({ id: 2, name: "Bob", age: 30 })
    end

    context "with multiple matching items" do
      let(:left_items) do
        [
          { id: 1, name: "Alice" },
          { id: 2, name: "Bob" },
          { id: 3, name: "Charlie" }
        ]
      end
      let(:right_items) do
        [
          { id: 4, age: 30 },
          { id: 2, age: 35 },
          { id: 3, age: 25 }
        ]
      end

      it "returns all matching items from both arrays" do
        result = collect(left_items).inner_join(right_items, :id, :id).all
        expect(result).to contain_exactly(
          { id: 2, name: "Bob", age: 35 },
          { id: 3, name: "Charlie", age: 25 }
        )
      end
    end
  end

  describe "#left_join" do
    let(:left_items) do
      [
        { id: 1, name: "Alice" },
        { id: 2, name: "Bob" },
        { id: 3, name: "Charlie" }
      ]
    end

    let(:right_items) do
      [
        { user_id: 1, age: 30 },
        { user_id: 2, age: 25 },
        { user_id: 4, age: 40 }
      ]
    end

    it "joins two arrays of hashes by specified keys" do
      result = collect(left_items).left_join(right_items, :id, :user_id).all

      expect(result).to contain_exactly(
        { id: 1, name: "Alice", user_id: 1, age: 30 },
        { id: 2, name: "Bob", user_id: 2, age: 25 },
        { id: 3, name: "Charlie", user_id: nil, age: nil } # No matching entry in right_items, so attributes set to nil
      )
    end

    it "handels left join collection" do
      result = collect(left_items).left_join(collect(right_items), :id, :user_id).all

      expect(result).to contain_exactly(
        { id: 1, name: "Alice", user_id: 1, age: 30 },
        { id: 2, name: "Bob", user_id: 2, age: 25 },
        { id: 3, name: "Charlie", user_id: nil, age: nil }
      )
    end

    it "handles right items with no matching left items" do
      result = collect([]).left_join(right_items, :id, :user_id).all
      expect(result).to eq([])
    end
  end

  describe "#right_join" do
    let(:left_items) do
      [
        { id: 1, name: "Alice" },
        { id: 2, name: "Bob" },
        { id: 3, name: "Charlie" }
      ]
    end

    let(:right_items) do
      [
        { user_id: 1, age: 30 },
        { user_id: 2, age: 25 },
        { user_id: 4, age: 40 }
      ]
    end

    it "performs a right outer join on items based on specified keys" do
      result = described_class.new(left_items).right_join(right_items, :id, :user_id).all

      expect(result).to contain_exactly(
        { id: 1, name: "Alice", user_id: 1, age: 30 },
        { id: 2, name: "Bob", user_id: 2, age: 25 },
        { user_id: 4, age: 40, id: nil, name: nil } # Non-matching left item attributes set to nil
      )
    end

    it "returns all items from the right array when there are no matching keys" do
      left_items = [
        { id: 1, name: "Alice" },
        { id: 2, name: "Bob" }
      ]
      right_items = [
        { user_id: 3, age: 30 },
        { user_id: 4, age: 25 }
      ]

      result = described_class.new(left_items).right_join(right_items, :id, :user_id).all

      expect(result).to contain_exactly(
        { user_id: 3, age: 30, id: nil, name: nil },
        { user_id: 4, age: 25, id: nil, name: nil }
      )
    end
  end

  describe ".full_join" do
    let(:left_items) do
      [
        { id: 1, name: "Alice" },
        { id: 2, name: "Bob" },
        { id: 3, name: "Charlie" }
      ]
    end

    let(:right_items) do
      [
        { user_id: 1, age: 30 },
        { user_id: 2, age: 25 },
        { user_id: 4, age: 40 }
      ]
    end

    it "performs a full outer join on two arrays of hashes by specified keys" do
      result = collect(left_items).full_join(right_items, :id, :user_id).all

      expect(result).to contain_exactly(
        { id: 1, name: "Alice", user_id: 1, age: 30 },
        { id: 2, name: "Bob", user_id: 2, age: 25 },
        { id: 3, name: "Charlie", user_id: nil, age: nil }, # Non-matching left item attributes set to nil
        { user_id: 4, age: 40, id: nil, name: nil } # Non-matching right item attributes set to nil
      )
    end

    it "returns all items from both arrays when there are no matching keys" do
      left_items = [
        { id: 1, name: "Alice" },
        { id: 2, name: "Bob" },
        { id: 5, name: "John" }
      ]
      right_items = [
        { user_id: 3, age: 30 },
        { user_id: 4, age: 25 },
        { user_id: 5, age: 25 }
      ]

      result = collect(left_items).full_join(right_items, :id, :user_id).all
      expect(result).to contain_exactly(
        { id: 1, name: "Alice", user_id: nil, age: nil }, # Non-matching left item attributes set to nil
        { id: 2, name: "Bob", user_id: nil, age: nil }, # Non-matching left item attributes set to nil
        { id: 5, name: "John", user_id: 5, age: 25 },
        { user_id: 3, age: 30, id: nil, name: nil }, # Non-matching right item attributes set to nil
        { user_id: 4, age: 25, id: nil, name: nil } # Non-matching right item attributes set to nil
      )
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
               .where(:a, ">", 1)
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

  context "when it chained with JSON input" do
    let(:json_items) do
      [
        { "a" => 3, "b" => 1, "x" => [1, 2, 3] },
        { "a" => 1, "b" => 2, "x" => [] },
        { "a" => 2, "b" => 3, "x" => [2, 3] },
        nil
      ]
    end

    it "returns correct output" do
      json_input = json_items

      result = collect(json_input)
               .where_not_nil
               .where(:a, ">", 1)
               .append({ "a" => 0, "b" => 2 })
               .prepend({ "a" => 4, "b" => 2 })
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

      expected_result = [
        { a: 0, b: 2, c: 2, x: [] },
        { a: 2, b: 3, c: 5, x: [2, 3] },
        { a: 3, b: 1, c: 4, x: [1, 2, 3] },
        { a: 4, b: 2, c: 6, x: [] }
      ]

      expect(result).to eq(expected_result)
    end
  end
end
