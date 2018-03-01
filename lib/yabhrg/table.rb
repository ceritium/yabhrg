require "time"

require "yabhrg/responses/employee_table"
require "yabhrg/responses/table_changes"
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

    def changes_since(table_name, since_at = nil)
      path = "employees/changed/tables/#{table_name}"
      if since_at
        since_at = Time.parse(since_at) if since_at.is_a?(String)
        path = "#{path}?since=#{since_at.iso8601}"
      end
      xml = get(path).body
      Responses::TableChanges.parse(xml)
    end

    private

    def base_path(employee_id, table_name)
      "employees/#{employee_id}/tables/#{table_name}"
    end
  end
end
