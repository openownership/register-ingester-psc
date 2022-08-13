require 'base64'
require 'json'

require 'register_ingester_psc/config/adapters'
require 'register_ingester_psc/streams/config'
require 'register_ingester_psc/streams/structs/psc_stream'

module RegisterIngesterPsc
  module Streams
    module Clients
      class PscStream
        URL = "https://stream.companieshouse.gov.uk/persons-with-significant-control"

        def initialize(http_adapter: nil, api_key: nil)
          @http_adapter = http_adapter || RegisterIngesterPsc::Config::Adapters::HTTP_ADAPTER
          @api_key = api_key || Streams::Config::PSC_STREAM_API_KEY
        end

        def read_stream(timepoint: nil)
          http_adapter.get(
            URL,
            params: {
              timepoint: timepoint
            }.compact,
            headers: {
              Authorization: "Basic #{basic_auth_key}"
            }
          ) do |content|
            parsed = JSON.parse(content, symbolize_names: true)
            yield RegisterIngesterPsc::Streams::PscStream.new(**parsed)
          end
        end

        private

        attr_reader :http_adapter, :api_key

        def basic_auth_key
          Base64.encode64(api_key + ':').strip
        end
      end
    end
  end
end
