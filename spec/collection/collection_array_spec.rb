# frozen_string_literal: true

require "spec_helper"

RSpec.describe Collection::CollectionArray do
  describe ".where" do
    context "with an correct number of arguments" do
      it "filters array based on key-value equality" do
        array = [
          { name: "John" },
          { name: "Jane" },
          { name: "Doe" }
        ]
        result = described_class.where(array, :name, "Jane")
        expect(result).to eq(
          [
            { name: "Jane" }
          ]
        )
      end

      it "filters array based on key-value inequality" do
        array = [
          { age: 20 },
          { age: 30 },
          { age: 40 }
        ]
        result = described_class.where(array, :age, "!=", 30)
        expect(result).to eq(
          [
            { age: 20 },
            { age: 40 }
          ]
        )
      end

      it "filters array based on numeric comparison" do
        array = [
          { age: 20 },
          { age: 30 },
          { age: 40 }
        ]
        result = described_class.where(array, :age, ">", 25)
        expect(result).to eq(
          [
            { age: 30 },
            { age: 40 }
          ]
        )
      end

      it "filters array based on string comparison" do
        array = [
          { name: "John" },
          { name: "Jane" },
          { name: "Doe" }
        ]
        result = described_class.where(array, :name, "LIKE", "Jo")
        expect(result).to eq(
          [
            { name: "John" }
          ]
        )
      end

      it "filters array based on negated string comparison" do
        array = [
          { name: "John" },
          { name: "Jane" },
          { name: "Doe" }
        ]
        result = described_class.where(array, :name, "NOT LIKE", "Jane")
        expect(result).to eq(
          [
            { name: "John" },
            { name: "Doe" }
          ]
        )
      end
    end

    context "with an incorrect number of arguments" do
      it "raises ArgumentError" do
        array = [{ a: 1 }, { a: 2 }, { a: 3 }]

        # Pass only one argument instead of two or three
        expect { described_class.where(array, :a) }.to raise_error(ArgumentError, "Invalid number of arguments")
      end
    end
  end

  describe ".where_not_nil" do
    it "filters out nil values from array" do
      array = [1, nil, 3, nil, 5]
      result = described_class.where_not_nil(array)
      expect(result).to eq([1, 3, 5])
    end

    it "returns empty array if all values are nil" do
      array = [nil, nil, nil]
      result = described_class.where_not_nil(array)
      expect(result).to eq([])
    end

    it "returns the original array if no nil values are present" do
      array = [1, 2, 3, 4, 5]
      result = described_class.where_not_nil(array)
      expect(result).to eq([1, 2, 3, 4, 5])
    end
  end

  describe ".wrap" do
    context "when given nil value" do
      it "returns an empty array" do
        expect(described_class.wrap(nil)).to eq([])
      end
    end

    context "when given a single value" do
      it "returns an array containing the value" do
        expect(described_class.wrap(1)).to eq([1])
      end
    end

    context "when given an array" do
      it "returns the same array" do
        array = [1, 2, 3]
        expect(described_class.wrap(array)).to eq(array)
      end
    end
  end

  describe ".append" do
    it "appends elements to the end of the array" do
      array = [1, 2, 3]
      result = described_class.append(array, 4, 5)
      expect(result).to eq([1, 2, 3, 4, 5])
    end
  end

  describe ".prepend" do
    it "prepends elements to the beginning of the array" do
      array = [3, 4, 5]
      result = described_class.prepend(array, 1, 2)
      expect(result).to eq([1, 2, 3, 4, 5])
    end
  end

  describe ".map" do
    it "applies the block to each element of the array" do
      array = [1, 2, 3]
      result = described_class.map(array) { |x| x * 2 }
      expect(result).to eq([2, 4, 6])
    end
  end

  describe ".map_with_keys" do
    it "applies the block to each value of the hash and retains the keys" do
      hash = { a: 1, b: 2, c: 3 }
      result = described_class.map_with_keys(hash) { |x| x * 2 }
      expect(result).to eq({ a: 2, b: 4, c: 6 })
    end
  end

  describe ".key_by" do
    it "transforms attributes using a block and add key as value based on given input" do
      records = [
        { "badgenumber" => 123, "first_checkin" => "2024-03-01", "last_checkout" => "2024-03-02" },
        { "badgenumber" => 1, "first_checkin" => "2024-03-03", "last_checkout" => "2024-03-04" }
      ]

      result = described_class.key_by(records, "badgenumber") do |record|
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

  describe ".except" do
    it "filters out specified keys from each hash in the array" do
      array = [{ a: 1, b: 2, c: 3 }, { a: 4, b: 5, c: 6 }]
      result = described_class.except(array, :b, :c)
      expect(result).to eq([{ a: 1 }, { a: 4 }])
    end

    it "raises an ArgumentError when empty key list is provided" do
      array = [{ a: 1, b: 2, c: 3 }, { a: 4, b: 5, c: 6 }]
      expect { described_class.except(array) }.to raise_error(ArgumentError, "Empty key list")
    end
  end

  describe ".only" do
    it "filters in specified keys from each hash in the array" do
      array = [{ a: 1, b: 2, c: 3 }, { a: 4, b: 5, c: 6 }]
      result = described_class.only(array, :b, :c)
      expect(result).to eq([{ b: 2, c: 3 }, { b: 5, c: 6 }])
    end

    it "raises an ArgumentError when empty key list is provided" do
      array = [{ a: 1, b: 2, c: 3 }]
      expect { described_class.only(array) }.to raise_error(ArgumentError, "Empty key list")
    end
  end

  describe ".diff" do
    it "returns the symmetric difference between two arrays" do
      array1 = [1, 2, 3, 4]
      array2 = [3, 4, 5, 6]

      result = described_class.diff(array1, array2)
      expect(result).to contain_exactly(1, 2, 5, 6)
    end

    it "returns an empty array if both arrays are identical" do
      array1 = [1, 2, 3]
      array2 = [1, 2, 3]

      result = described_class.diff(array1, array2)
      expect(result).to be_empty
    end

    it "returns the elements of the first array if the second array is empty" do
      array1 = [1, 2, 3]
      array2 = []

      result = described_class.diff(array1, array2)
      expect(result).to eq([1, 2, 3])
    end

    it "returns the elements of the second array if the first array is empty" do
      array1 = []
      array2 = [1, 2, 3]

      result = described_class.diff(array1, array2)
      expect(result).to eq([1, 2, 3])
    end
  end
end