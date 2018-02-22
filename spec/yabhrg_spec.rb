RSpec.describe Yabhrg do
  it "has a version number" do
    expect(Yabhrg::VERSION).not_to be nil
  end

  it ".api" do
    api = described_class.api(api_key: "foo", subdomain: "bar")
    expect(api).to be_a(Yabhrg::API)
  end
end
