RSpec.describe Yabhrg::API do
  subject(:api) { described_class.new(api_key: "foo", subdomain: "bar") }

  describe "#employee" do
    it "instantiate a Employee" do
      expect(api.employee).to be_a(Yabhrg::Employee)
    end

    it "memoize the instance" do
      e1 = api.employee
      e2 = api.employee

      expect(e1).to be(e2)
    end
  end

  describe "#metadata" do
    it "instantiate a Metadata" do
      expect(api.metadata).to be_a(Yabhrg::Metadata)
    end

    it "memoize the instance" do
      m1 = api.metadata
      m2 = api.metadata

      expect(m1).to be(m2)
    end
  end
end
