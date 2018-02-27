RSpec.describe Yabhrg::Generators::AddFileCategory do
  describe ".generate" do
    it "proper xml" do
      response = described_class.generate("foo")
      expected_response = <<-XML
<employee>
  <category>foo</category>
</employee>
      XML

      expect(response.strip).to eq(expected_response.strip)
    end
  end
end
