require "pry"
module Yabhrg
  # Defines HTTP request methods
  module Request
    class NonSuccessResponse < StandardError
      attr_reader :response

      def initialize(response)
        @response = response
        super("#{response.status} #{response.body}")
      end
    end

    private

    # Perform an HTTP GET request
    def get(path, options = {}, raw = false)
      request(:get, path, options, raw)
    end

    # Perform an HTTP POST request
    def post(path, options = {}, raw = false)
      request(:post, path, options, raw)
    end

    # Perform an HTTP PUT request
    def put(path, options = {}, raw = false)
      request(:put, path, options, raw)
    end

    # Perform an HTTP DELETE request
    def delete(path, options = {}, raw = false)
      request(:delete, path, options, raw)
    end

    # Perform an HTTP request
    def request(method, path, options, _raw = false)
      response = connection.send(method) do |request|
        request.headers["Accept"] = "application/json"
        case method
        when :get, :delete
          request.url(path, options)
        when :post, :put
          request.path = path
          request.body = options unless options.empty?
        end
      end

      raise NonSuccessResponse, response if response.status >= 400
      response.body
    end
  end
end
