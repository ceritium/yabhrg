require "yabhrg/version"

require "yabhrg/api"
require "yabhrg/client"

module Yabhrg
  class << self
    def api(options = {})
      API.new(options)
    end
  end
end
