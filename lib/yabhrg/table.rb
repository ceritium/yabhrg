require "yabhrg/responses/employee_table"
require "yabhrg/generators/row_fields"

module Yabhrg
  class Table < Client
    def rows(employee_id, table_name)
      path = base_path(employee_id, table_name)
      response = get(path).body
      Responses::EmployeeTable.parse(response)
    end

    def update_row(employee_id, table_name, row_id, attrs = {})
      body = Generators::RowFields.generate(attrs)
      path = "#{base_path(employee_id, table_name)}/#{row_id}"
      post(path, body: body).success?
    end

    def add_row(employee_id, table_name, attrs = {})
      body = Generators::RowFields.generate(attrs)
      path = base_path(employee_id, table_name)
      post(path, body: body).success?
    end

    private

    def base_path(employee_id, table_name)
      "employees/#{employee_id}/tables/#{table_name}"
    end
  end
end
