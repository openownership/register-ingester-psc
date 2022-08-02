require 'base64'
require 'json'
require 'register_ingester_psc/structs/corporate_entity'
require 'register_ingester_psc/structs/legal_person'
require 'register_ingester_psc/structs/individual'
require 'register_ingester_psc/streams/structs/psc_stream'

module RegisterIngesterPsc
  module Streams
    module Clients
      class PscStream
        URL = "https://stream.companieshouse.gov.uk/persons-with-significant-control"

        def initialize(http_adapter: HTTP_ADAPTER, api_key: SECRETS.psc_stream_api_key)
          @http_adapter = http_adapter
          @api_key = api_key
        end

        def read_stream(timepoint: 3408528)
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

            case parsed.dig(:data, :kind)
            when "individual-person-with-significant-control"
              parsed[:data] = RegisterIngesterPsc::Individual.new(parsed[:data])
            when "corporate-entity-person-with-significant-control"
              parsed[:data] = RegisterIngesterPsc::CorporateEntity.new(parsed[:data])
            when "legal-person-person-with-significant-control"
              parsed[:data] = RegisterIngesterPsc::LegalPerson.new(parsed[:data])
            end
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
