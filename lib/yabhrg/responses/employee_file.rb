module Yabhrg
  module Responses
    module EmployeeFile
      class << self
        def parse(response)
          data = response.headers.select { |x, _v| x.start_with?("content-") }
          data[:body] = response.body
          data
        end
      end
    end
  end
end
