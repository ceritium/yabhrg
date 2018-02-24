RSpec.describe Yabhrg::Generators::MetadataListOptions do
  describe ".generate" do
    it "empty" do
      response = described_class.generate
      expect(response).to eq("<options/>")
    end

    it "with a string item" do
      response = described_class.generate(["foo"])
      expected_response = <<-XML
<options>
  <option>foo</option>
</options>
      XML
      expect(response.strip).to eq(expected_response.strip)
    end

    it "with a hash item" do
      item = { id: "42", archived: "no", value: "foo" }

      response = described_class.generate([item])
      expected_response = <<-XML
<options>
  <option id="42" archived="no">foo</option>
</options>
      XML
      expect(response.strip).to eq(expected_response.strip)
    end
  end
end
