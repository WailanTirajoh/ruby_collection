# frozen_string_literal: true

RSpec.describe Collection do
  it "has a version number" do
    expect(Collection::VERSION).not_to be_nil
  end
end
