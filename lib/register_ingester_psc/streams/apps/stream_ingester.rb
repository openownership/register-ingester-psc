require 'logger'

require 'register_ingester_psc/config/settings'
require 'register_sources_psc/config/elasticsearch'
require 'register_sources_psc/repositories/company_record_repository'
require 'register_ingester_psc/streams/clients/psc_stream'

module RegisterIngesterPsc
  module Streams
    module Apps
      class StreamIngester
        def self.bash_call(args)
          timepoint = args[0] && Integer(args[0])

          StreamIngester.new.call(timepoint: timepoint)
        end

        def initialize(stream_client: nil, repository: nil)
          @stream_client = stream_client || Streams::Clients::PscStream.new
          @repository = repository || RegisterSourcesPsc::Repositories::CompanyRecordRepository.new(
            client: RegisterSourcesPsc::Config::ELASTICSEARCH_CLIENT)
          @logger = Logger.new(STDOUT)
        end

        def call(timepoint: nil)
          # "timepoint":4178539,"published_at":"2022-08-13T15:55:01"
          stream_client.read_stream(timepoint: timepoint) do |record|
            print("GOT RECORD: ", record, "\n")
            repository.store([record])

            # TODO: store offset
          end
        end

        private

        attr_reader :stream_client, :repository, :logger
      end
    end
  end
end
