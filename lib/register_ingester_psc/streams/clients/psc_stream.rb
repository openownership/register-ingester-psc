# frozen_string_literal: true

require 'base64'
require 'json'
require 'register_sources_psc/structs/psc_stream'

require_relative '../../config/adapters'
require_relative '../config'

module RegisterIngesterPsc
  module Streams
    module Clients
      class TimepointError < StandardError; end

      class PscStream
        URL = 'https://stream.companieshouse.gov.uk/persons-with-significant-control'

        def initialize(http_adapter: nil, api_key: nil)
          @http_adapter = http_adapter || RegisterIngesterPsc::Config::Adapters::HTTP_ADAPTER
          @api_key = api_key || Streams::Config::PSC_STREAM_API_KEY
        end

        def read_stream(timepoint: nil)
          timepoint_err = true
          @http_adapter.get(
            URL,
            params: {
              timepoint:
            }.compact,
            headers: {
              Authorization: "Basic #{basic_auth_key}"
            }
          ) do |content|
            timepoint_err = false
            parsed = JSON.parse(content, symbolize_names: true)
            match = %r{/company/(?<company_number>\w+)/}.match(parsed[:resource_uri])
            parsed[:company_number] = match[:company_number] if match
            yield RegisterSourcesPsc::PscStream.new(**parsed)
          end
          raise TimepointError if timepoint_err
        end

        private

        def basic_auth_key
          Base64.encode64("#{@api_key}:").strip
        end
      end
    end
  end
end
