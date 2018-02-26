require "yabhrg/generators/employee_add"

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
      post("employees", body)
    end

    def update(id, attrs = {})
      body = Generators::EmployeeAdd.generate(attrs)
      put("employees/#{id}", body)
    end

    def field_list(reload = false)
      memoize(reload) do
        @field_list = api.metadata.fields(reload).map { |x| x["alias"] }.compact
      end
    end
  end
end
