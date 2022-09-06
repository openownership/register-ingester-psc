require 'register_ingester_psc/config/settings'
require 'register_ingester_psc/config/adapters'
require 'register_ingester_psc/record_serializer'
require 'register_common/services/publisher'

module RegisterIngesterPsc
  class RecordsProducer
    def initialize(stream_name: nil, kinesis_adapter: nil, buffer_size: nil, serializer: nil)
      stream_name ||= ENV['PSC_STREAM']
      kinesis_adapter ||= RegisterIngesterPsc::Config::Adapters::KINESIS_ADAPTER
      buffer_size ||= 50
      serializer ||= RecordSerializer.new

      @publisher = RegisterCommon::Services::Publisher.new(
        stream_name: stream_name,
        kinesis_adapter: kinesis_adapter,
        buffer_size: buffer_size,
        serializer: serializer
      )
    end

    def produce(records)
      records.each do |record|
        publisher.publish(record)
      end
    end

    def finalize
      publisher.finalize
    end

    private

    attr_reader :publisher
  end
end
