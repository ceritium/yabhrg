require "yabhrg/client"
require "yabhrg/employee"
require "yabhrg/metadata"
require "yabhrg/table"

module Yabhrg
  class API
    def initialize(options = {})
      @options = options
    end

    def employee
      @employee ||= Employee.new(config)
    end

    def metadata
      @metadata ||= Metadata.new(config)
    end

    def table
      @table ||= Table.new(config)
    end

    private

    def config
      @options.merge(api: self)
    end
  end
end
