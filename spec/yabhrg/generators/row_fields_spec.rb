RSpec.describe Yabhrg::Generators::RowFields do
  describe ".generate" do
    it "empty" do
      response = described_class.generate
      expect(response).to eq("<row/>")
    end

    it "with a pair of attributes" do
      response = described_class.generate(foo: :bar, bar: :foo)
      expected_response = <<-XML
<row>
  <field id="foo">bar</field>
  <field id="bar">foo</field>
</row>
      XML

      expect(response.strip).to eq(expected_response.strip)
    end
  end
end
