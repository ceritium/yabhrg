RSpec.describe Yabhrg::Responses::EmployeeFiles do
  describe ".parse" do
    it "from example" do
      xml = <<-XML
<employee id="123">
    <category id="1">
        <name>New Hire Docs</name>
        <file id="1234">
            <name>Employee handbook</name>
            <originalFileName>employee_handbook.doc</originalFileName>
            <size>23552</size>
            <dateCreated>2011-06-28 16:50:52</dateCreated>
            <createdBy>John Doe</createdBy>
            <shareWithEmployee>yes</shareWithEmployee>
        </file>
    </category>
    <category id="112">
        <name>Training Docs</name>
    </category>
</employee>
      XML

      expected_result = {
        categories: [
          {
            id: "1",
            name: "New Hire Docs",
            files: [
              {
                id: "1234",
                name: "Employee handbook",
                original_file_name: "employee_handbook.doc",
                size: "23552",
                date_created: "2011-06-28 16:50:52",
                created_by: "John Doe",
                share_with_employee: "yes"
              }
            ]
          },
          {
            id: "112",
            name: "Training Docs",
            files: []
          }
        ]
      }

      result = described_class.parse(xml)
      expect(result).to eq(expected_result)
    end
  end
end
