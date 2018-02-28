RSpec.describe Yabhrg::Responses::EmployeeTable do
  describe ".parse" do
    it "from example" do
      xml = <<-XML
<table>
    <row id="1" employeeId="100">
        <field id="department">Research and Development</field>
        <field id="jobTitle">Machinist</field>
        <field id="reportsTo">John Smith</field>
    </row>
    <row id="2" employeeId="100">
        <field id="department">Sales</field>
        <field id="jobTitle">Salesman</field>
        <field id="reportsTo">Jane Doe</field>
    </row>
</table>
      XML

      expected_result = [
        {
          id: "1",
          employee_id: "100",
          fields: {
            "department" => "Research and Development",
            "jobTitle" => "Machinist",
            "reportsTo" => "John Smith"
          }
        },
        {
          id: "2",
          employee_id: "100",
          fields: {
            "department" => "Sales",
            "jobTitle" => "Salesman",
            "reportsTo" => "Jane Doe"
          }
        }
      ]

      result = described_class.parse(xml)
      expect(result).to eq(expected_result)
    end
  end
end
