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

    def field_list(reload = false)
      if @field_list.nil? || reload
        @field_list = api.metadata.fields(reload).map { |x| x["alias"] }.compact
      end

      @field_list
    end
  end
end
