module Yabhrg
  module Responses
    module TableChanges
      class << self
        def parse(xml)
          doc = Nokogiri::XML(xml)
          {
            table: doc.xpath("table")[0]["id"],
            employees: parse_employees(doc.xpath("table/employee"))
          }
        end

        private

        def parse_employees(employees)
          employees.each_with_object([]) do |employee, memo|
            memo << {
              id: employee["id"],
              last_changed: employee["lastChanged"],
              rows: parse_rows(employee.xpath("row"))
            }
          end
        end

        def parse_rows(rows)
          rows.each_with_object([]) do |row, memo|
            memo << parse_fields(row.xpath("field"))
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
