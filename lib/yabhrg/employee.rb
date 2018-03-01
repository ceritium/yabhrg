require "mimemagic"

require "yabhrg/generators/add_file_category"
require "yabhrg/generators/employee_add"
require "yabhrg/generators/employee_update_file"
require "yabhrg/generators/custom_report"
require "yabhrg/responses/employee_files"
require "yabhrg/responses/employee_file"

module Yabhrg
  class Employee < Client
    def all
      JSON.parse(get("employees/directory").body)
    end

    # Use one of these in the {type} variable in the URL: "inserted", "updated", "deleted"
    # The "since" parameter is an ISO 8601 date.
    #
    # https://www.bamboohr.com/api/documentation/changes.php
    def changes_since(since_at: nil, type: nil)
      path = "employees/changed"

      query = {}

      if since_at
        since_at = Time.parse(since_at) if since_at.is_a?(String)
        query[:since] = since_at.iso8601
      end

      query[:type] = type if type

      query_string = query.map { |k, v| "#{k}=#{v}" }.join("&")

      path = "#{path}?#{query_string}" if query_string

      JSON.parse(get(path).body)
    end

    def find(employee_id, fields: :all)
      query = if fields == :all
                field_list
              else
                fields
              end.join(",")

      JSON.parse(get("employees/#{employee_id}?fields=#{query}").body)
    end

    def field_list(reload = false)
      memoize(reload) do
        @field_list = api.metadata.fields(reload).map { |x| x["alias"] }.compact
      end
    end

    def add(attrs = {})
      body = Generators::EmployeeAdd.generate(attrs)
      post("employees", body: body).success?
    end

    def update(employee_id, attrs = {})
      body = Generators::EmployeeAdd.generate(attrs)
      put("employees/#{employee_id}", body: body).success?
    end

    def report(report_id, fd: "yes")
      JSON.parse(raw_report(report_id, format: "json", fd: fd).body)
    end

    def raw_report(report_id, format: "json", fd: "yes")
      get("reports/#{report_id}?format=#{format}&fd=#{fd}")
    end

    def custom_raw_report(title:, fields: [], format: "json")
      body = Generators::CustomReport.generate(title: title, fields: fields)
      post("reports/custom", body: body, params: { format: format }).body
    end

    def files(employee_id)
      xml = get("employees/#{employee_id}/files/view").body
      Responses::EmployeeFiles.parse(xml)
    end

    def add_file_category(category_name)
      body = Generators::AddFileCategory.generate(category_name)
      post("employees/files/categories/", body: body).success?
    end

    def update_employee_file(employee_id, file_id, attrs = {})
      body = Generators::EmployeeUpdateFile.generate(attrs)
      post("employees/#{employee_id}/files/#{file_id}", body: body).success?
    end

    def delete_employee_file(employee_id, file_id)
      delete("employees/#{employee_id}/files/#{file_id}").success?
    end

    def employee_file(employee_id, file_id)
      response = get("employees/#{employee_id}/files/#{file_id}")
      Responses::EmployeeFile.parse(response)
      data = response.headers.select { |x, _v| x.start_with?("content-") }
      data[:body] = response.body
      data
    end

    def upload_employee_file(employee_id, options = {})
      file_path = options.fetch(:file_path)
      category_id = options.fetch(:category_id)
      file_name = options.fetch(:file_name)
      share = options.fetch(:share, "no")

      file_type = options.fetch(:file_type, nil)
      file_type ||= MimeMagic.by_magic(File.open(file_path))

      payload = {
        file: Faraday::UploadIO.new(file_path, file_type),
        fileName: file_name,
        category: category_id,
        share: share
      }

      connection.post("employees/#{employee_id}/files", payload).success?
    end

    # TODO: Company files
  end
end
