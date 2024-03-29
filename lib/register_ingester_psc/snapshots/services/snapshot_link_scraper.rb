# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

require_relative '../../config/adapters'

module RegisterIngesterPsc
  module Snapshots
    module Services
      class SnapshotLinkScraper
        FILENAME_REGEX = /^psc-snapshot-\d{4}-\d{2}-\d{2}_\d+of\d+.zip$/
        SOURCE_URL     = 'https://download.companieshouse.gov.uk/en_pscdata.html'

        def initialize(http_adapter: Config::Adapters::HTTP_ADAPTER, source_url: SOURCE_URL)
          @http_adapter = http_adapter
          @source_url = source_url
        end

        def list_links
          # calculate base url
          source_uri = URI.parse(source_url)
          base_url = "#{source_uri.scheme}://#{source_uri.host}"

          # download page
          response = http_adapter.get(source_url)

          # parse and process page
          links = []
          Nokogiri::HTML(response.body).css('a').each_with_object([]) do |el, _acc|
            href = el['href']
            links << "#{base_url}/#{href}" if href && !href.empty? && href.match(FILENAME_REGEX)
          end

          links
        end

        private

        attr_reader :http_adapter, :source_url
      end
    end
  end
end
