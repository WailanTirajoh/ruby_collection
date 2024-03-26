# frozen_string_literal: true

RSpec.describe ArrayCollection do
  it "has a version number" do
    expect(ArrayCollection::VERSION).not_to be_nil
  end
end
