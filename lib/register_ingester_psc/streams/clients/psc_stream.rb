require 'base64'
require 'json'
require 'logger'

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
          @logger = Logger.new(STDOUT)
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
            logger.info "RECEIVED CONTENT: #{content}\n"
            parsed = JSON.parse(content, symbolize_names: true)

            resource_uri = parsed[:resource_uri]
            match = /\/company\/(?<company_number>\d+)\//.match(resource_uri)
            if match
              parsed[:company_number] = match[:company_number]
            end

            yield RegisterIngesterPsc::Streams::PscStream.new(**parsed)
          end
        end

        private

        attr_reader :http_adapter, :api_key, :logger

        def basic_auth_key
          Base64.encode64(api_key + ':').strip
        end
      end
    end
  end
end
