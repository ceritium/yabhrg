require "json"

require "faraday"
require "faraday_middleware"

require "yabhrg/request"
require "yabhrg/memoize"

module Yabhrg
  class Client
    include Request
    include Memoize

    USER_AGENT = "Yabhrg #{VERSION}".freeze
    DUMMY_PASS = "x".freeze # Specified by the API documentation

    attr_reader :api_key, :subdomain

    def initialize(api_key:, subdomain:, api: nil)
      @api_key = api_key
      @subdomain = subdomain
      @api = api || API.new(api_key: api_key, subdomain: subdomain)
    end

    def endpoint
      "https://api.bamboohr.com/api/gateway.php/#{subdomain}/v1"
    end

    private

    attr_reader :api

    def config
      {
        api_key: api_key,
        subdomain: subdomain
      }
    end

    def conn_options
      {
        headers: { "User-Agent" => USER_AGENT },
        url: endpoint
      }
    end

    def connection
      Faraday::Connection.new(conn_options) do |conn|
        # conn.response :xml,  :content_type => /\bxml$/
        # conn.response :json, :content_type => /\bjson$/
        conn.basic_auth(api_key, DUMMY_PASS)
        conn.adapter(Faraday.default_adapter)
      end
    end
  end
end
