# frozen_string_literal: true

require 'logger'
require 'redis'

require_relative '../../config/settings'
require_relative '../../records_handler'
require_relative '../clients/psc_stream'

module RegisterIngesterPsc
  module Streams
    module Apps
      class StreamIngester
        REDIS_NS = 'ingester-psc/'

        REDIS_TIMEPOINT = "#{REDIS_NS}timepoint".freeze

        def self.bash_call(args)
          timepoint = args[0] && Integer(args[0])
          StreamIngester.new.call(timepoint:)
        end

        def initialize(stream_client: nil, records_handler: nil)
          @stream_client = stream_client || Streams::Clients::PscStream.new
          @records_handler = records_handler || RecordsHandler.new
          @logger = Logger.new($stdout)
          @redis = Redis.new(url: ENV.fetch('REDIS_URL'))
        end

        def call(timepoint: nil)
          @redis.set(REDIS_TIMEPOINT, timepoint) if timepoint
          timepoint = @redis.get(REDIS_TIMEPOINT)
          timepoint = timepoint.to_i if timepoint
          @logger.info "TIMEPOINT: #{timepoint}"
          @stream_client.read_stream(timepoint:) do |stream_record|
            timepoint = stream_record[:event][:timepoint]
            @logger.debug "[#{timepoint}] #{stream_record[:resource_uri]}"
            record = RegisterSourcesPsc::CompanyRecord[stream_record]
            @records_handler.handle_records([record])
            @redis.set(REDIS_TIMEPOINT, timepoint)
          end
        rescue Streams::Clients::TimepointError
          @logger.fatal 'INVALID TIMEPOINT'
          @redis.del(REDIS_TIMEPOINT)
          raise
        end
      end
    end
  end
end
