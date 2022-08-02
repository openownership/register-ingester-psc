module RegisterIngesterPsc
  module Services
    class SnapshotReader
      def initialize(zip_reader: ZIP_READER)
        @zip_reader = zip_reader
      end

      def foreach_raw_record_record(stream, compressed: true)
        data_stream = compressed ? zip_reader.open_stream(stream) : stream

        data_stream.each do |line|
          line.force_encoding("UTF-8")

          yield Structs::RawDataRecord.new(
            raw_data: line,
            etag: JSON.parse(line).dig('data', 'etag')
          )
        end

        data_stream.close
      end

      private

      attr_reader :zip_reader
    end
    end
  end
end
