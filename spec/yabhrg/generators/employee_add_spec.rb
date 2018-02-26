RSpec.describe Yabhrg::Generators::EmployeeAdd do
  describe ".generate" do
    it "empty" do
      response = described_class.generate
      expect(response).to eq("<employee/>")
    end

    it "with a pair of attributes" do
      response = described_class.generate(foo: :bar, bar: :foo)
      expected_response = <<-XML
<employee>
  <field id="foo">bar</field>
  <field id="bar">foo</field>
</employee>
      XML

      expect(response.strip).to eq(expected_response.strip)
    end
  end
end
