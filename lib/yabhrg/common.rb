module Yabhrg
  module Common
    def employee
      Employee.new(config)
    end

    def metadata
      Metadata.new(config)
    end
  end
end
