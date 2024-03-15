# frozen_string_literal: true

require "spec_helper"

RSpec.describe Collection::CollectionArray do
  describe "#where" do
    it "filters array based on given callback" do
      array = [1, 2, 3, 4, 5]
      result = Collection::CollectionArray.where(array) { |v| v > 2 }
      expect(result).to eq([3, 4, 5])
    end

    it "returns empty array if callback does not match any element" do
      array = [1, 2, 3, 4, 5]
      result = Collection::CollectionArray.where(array) { |v| v > 5 }
      expect(result).to eq([])
    end
  end

  describe "#where_not_nil" do
    it "filters out nil values from array" do
      array = [1, nil, 3, nil, 5]
      result = Collection::CollectionArray.where_not_nil(array)
      expect(result).to eq([1, 3, 5])
    end

    it "returns empty array if all values are nil" do
      array = [nil, nil, nil]
      result = Collection::CollectionArray.where_not_nil(array)
      expect(result).to eq([])
    end

    it "returns the original array if no nil values are present" do
      array = [1, 2, 3, 4, 5]
      result = Collection::CollectionArray.where_not_nil(array)
      expect(result).to eq([1, 2, 3, 4, 5])
    end
  end

  describe "#wrap" do
    context "when given nil value" do
      it "returns an empty array" do
        expect(Collection::CollectionArray.wrap(nil)).to eq([])
      end
    end

    context "when given a single value" do
      it "returns an array containing the value" do
        expect(Collection::CollectionArray.wrap(1)).to eq([1])
      end
    end

    context "when given an array" do
      it "returns the same array" do
        array = [1, 2, 3]
        puts [1, 2, 3].is_a?(Array)
        expect(Collection::CollectionArray.wrap(array)).to eq(array)
      end
    end
  end

  describe "#append" do
    it "appends elements to the end of the array" do
      array = [1, 2, 3]
      result = Collection::CollectionArray.append(array, 4, 5)
      expect(result).to eq([1, 2, 3, 4, 5])
    end
  end

  describe "#prepend" do
    it "prepends elements to the beginning of the array" do
      array = [3, 4, 5]
      result = Collection::CollectionArray.prepend(array, 1, 2)
      expect(result).to eq([1, 2, 3, 4, 5])
    end
  end

  describe "#map" do
    it "applies the block to each element of the array" do
      array = [1, 2, 3]
      result = Collection::CollectionArray.map(array) { |x| x * 2 }
      expect(result).to eq([2, 4, 6])
    end
  end

  describe "#map_with_keys" do
    it "applies the block to each value of the hash and retains the keys" do
      hash = { a: 1, b: 2, c: 3 }
      result = Collection::CollectionArray.map_with_keys(hash) { |x| x * 2 }
      expect(result).to eq({ a: 2, b: 4, c: 6 })
    end
  end

  describe "#key_by" do
    it "transforms attributes using a block and add key as value based on given input" do
      records = [
        { "badgenumber" => 123, "first_checkin" => "2024-03-01", "last_checkout" => "2024-03-02" },
        { "badgenumber" => 1, "first_checkin" => "2024-03-03", "last_checkout" => "2024-03-04" }
      ]

      result = Collection::CollectionArray.key_by(records, "badgenumber") do |record|
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
end
