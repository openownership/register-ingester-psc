# frozen_string_literal: true

require 'register_common/services/publisher'

require_relative 'config/adapters'
require_relative 'config/settings'
require_relative 'record_serializer'

module RegisterIngesterPsc
  class RecordsProducer
    def initialize(stream_name:, kinesis_adapter: nil, buffer_size: nil, serializer: nil)
      kinesis_adapter ||= RegisterIngesterPsc::Config::Adapters::KINESIS_ADAPTER
      buffer_size ||= 50
      serializer ||= RecordSerializer.new

      @publisher = if stream_name
                     RegisterCommon::Services::Publisher.new(
                       stream_name:,
                       kinesis_adapter:,
                       buffer_size:,
                       serializer:
                     )
                   end
    end

    def produce(records)
      return unless publisher

      records.each do |record|
        publisher.publish(record)
      end
    end

    def finalize
      return unless publisher

      publisher.finalize
    end

    private

    attr_reader :publisher
  end
end
