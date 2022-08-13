require 'register_ingester_psc/config/settings'
require 'register_sources_psc/config/elasticsearch'
require 'register_sources_psc/repositories/company_record_repository'
require 'register_ingester_psc/streams/clients/psc_stream'

module RegisterIngesterPsc
  module Streams
    module Apps
      class StreamIngester
        def initialize(stream_client: nil, repository: nil)
          @stream_client = stream_client || Streams::Clients::PscStream.new
          @repository = repository || RegisterSourcesPsc::Repositories::CompanyRecordRepository.new(
            client: RegisterSourcesPsc::Config::ELASTICSEARCH_CLIENT)
        end

        def call
          stream_client.read_stream(timepoint: nil) do |record|
            repository.store([record])

            # TODO: store offset
          end
        end

        private

        attr_reader :stream_client, :repository
      end
    end
  end
end