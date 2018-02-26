require "yabhrg/generators/employee_add"
require "yabhrg/generators/custom_report"

module Yabhrg
  class Employee < Client
    def all
      JSON.parse(get("employees/directory"))
    end

    def find(id, fields: :all)
      query = if fields == :all
                field_list
              else
                fields
              end.join(",")

      JSON.parse(get("employees/#{id}?fields=#{query}"))
    end

    def add(attrs = {})
      body = Generators::EmployeeAdd.generate(attrs)
      post("employees", body: body)
    end

    def update(id, attrs = {})
      body = Generators::EmployeeAdd.generate(attrs)
      put("employees/#{id}", body: body)
    end

    def report(id, fd: "yes")
      JSON.parse(raw_report(id, format: "json", fd: fd))
    end

    def raw_report(id, format: "json", fd: "yes")
      get("reports/#{id}?format=#{format}&fd=#{fd}")
    end

    def custom_raw_report(title:, fields: [], format: "json")
      body = Generators::CustomReport.generate(title: title, fields: fields)
      post("reports/custom", body: body, params: { format: format })
    end

    def field_list(reload = false)
      memoize(reload) do
        @field_list = api.metadata.fields(reload).map { |x| x["alias"] }.compact
      end
    end
  end
end
