require 'register_common/utils/mixins/retry_with_backoff'

module RegisterIngesterPsc
  module Producers
    class RecordProducer
      include RegisterCommon::Utils::Mixins::RetryWithBackoff

      DEFAULT_BUFFER_SIZE = 20 # TODO: check size

      def initialize(
        stream_name:,
        kinesis_adapter:,
        buffer_size:
      )
        @stream_name = stream_name
        @kinesis_adapter = kinesis_adapter
        @buffer_size = buffer_size
        @buffer = []
      end

      def publish(msg)
        unless msg.is_a? String
          msg = msg.serialize
        end

        if msg[-1] != "\n"
          msg += "\n"
        end

        @buffer = buffer + [msg]

        return false unless buffer.length >= buffer_size

        flush_buffer
        true
      end

      def finalize
        flush_buffer
        true
      end

      private

      attr_reader :buffer, :buffer_size
      attr_reader :kinesis_adapter, :stream_name

      def flush_buffer
        return if buffer.empty?

        retry_with_backoff do
          kinesis_adapter.put_records(stream_name: stream_name, records: buffer)
        end

        @buffer = []
      end
    end
  end
end
