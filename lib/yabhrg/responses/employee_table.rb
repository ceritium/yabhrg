module Yabhrg
  module Responses
    module EmployeeTable
      class << self
        def parse(xml)
          doc = Nokogiri::XML(xml)
          doc.xpath("table/row").each_with_object([]) do |row, memo|
            memo << {
              id: row["id"],
              employee_id: row["employeeId"],
              fields: parse_fields(row.xpath("field"))
            }
          end
        end

        def parse_fields(fields)
          fields.each_with_object({}) do |field, memo|
            memo[field["id"]] = field.text
          end
        end
      end
    end
  end
end
