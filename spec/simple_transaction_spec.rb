require "spec_helper"

RSpec.describe SimpleTransaction do
  it "has a version number" do
    expect(SimpleTransaction::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
