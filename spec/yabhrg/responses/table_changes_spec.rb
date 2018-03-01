RSpec.describe Yabhrg::Responses::TableChanges do
  describe ".parse" do
    it "from example" do
      xml = File.read("spec/support/webmock/table_changes.xml")

      expected_result = {
        table: "jobInfo",
        employees: [
          {
            id: "123",
            last_changed: "2012-10-29T11:54:00Z",
            rows: [
              {
                "jobTitle" => "Machinist",
                "reportsTo" => "John Smith"
              },
              {
                "jobTitle" => "Shop hand",
                "reportsTo" => "John Smith"
              }
            ]
          },
          {
            id: "456",
            last_changed: nil,
            rows: [
              {
                "jobTitle" => "Designer",
                "reportsTo" => "Jane Doe"
              }
            ]
          }
        ]
      }
      result = described_class.parse(xml)
      expect(result).to eq(expected_result)
    end
  end
end
