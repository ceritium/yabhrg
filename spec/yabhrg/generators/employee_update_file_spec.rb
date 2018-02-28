RSpec.describe Yabhrg::Generators::EmployeeUpdateFile do
  describe ".generate" do
    it "proper xml" do
      response = described_class.generate(foo_bar: "foo bar")
      expected_response = <<-XML
<file>
  <fooBar>foo bar</fooBar>
</file>
      XML

      expect(response.strip).to eq(expected_response.strip)
    end
  end
end
