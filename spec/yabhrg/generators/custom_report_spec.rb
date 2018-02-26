RSpec.describe Yabhrg::Generators::CustomReport do
  describe ".generate" do
    it "empty" do
      response = described_class.generate(title: "foo")

      expected_response = <<-XML
<report>
  <title>foo</title>
  <filters/>
  <fields/>
</report>
      XML

      expect(response.strip).to eq(expected_response.strip)
    end

    it "with fields" do
      response = described_class.generate(title: "foo", fields: ["foo", "bar"])

      expected_response = <<-XML
<report>
  <title>foo</title>
  <filters/>
  <fields>
    <field id="foo"/>
    <field id="bar"/>
  </fields>
</report>
      XML

      expect(response.strip).to eq(expected_response.strip)
    end

    it "with filters" do
      input = {
        title: "foo",
        filters: {
          last_changed: {
            foo_bar: "barfoo", value: "thevalue"
          }
        }
      }

      response = described_class.generate(input)
      expected_response = <<-XML
<report>
  <title>foo</title>
  <filters>
    <lastChanged fooBar="barfoo">thevalue</lastChanged>
  </filters>
  <fields/>
</report>
      XML

      expect(response.strip).to eq(expected_response.strip)
    end
  end
end
