require 'register_common/services/file_reader'
require 'register_ingester_psc/snapshots/services/snapshot_row_processor'
require 'register_ingester_psc/config/adapters'

module RegisterIngesterPsc
  module Snapshots
    module Services
      class SnapshotReader
        SNAPSHOT_FILE_FORMAT = RegisterCommon::Parsers::FileFormats::JSON
        SNAPSHOT_COMPRESSION = RegisterCommon::Decompressors::CompressionTypes::GZIP
        BATCH_SIZE = 100

        def initialize(
          s3_adapter: nil,
          row_processor: nil,
          decompressor: nil,
          parser: nil,
          batch_size: BATCH_SIZE
        )
          @row_processor = row_processor || Services::SnapshotRowProcessor.new
          @file_reader = RegisterCommon::Services::FileReader.new(
            s3_adapter: s3_adapter || Config::Adapters::S3_ADAPTER,
            decompressor: decompressor,
            parser: parser,
            batch_size: batch_size
          )
        end

        def read_from_s3(s3_bucket:, s3_path:, file_format: SNAPSHOT_FILE_FORMAT, compression: SNAPSHOT_COMPRESSION)
          file_reader.read_from_s3(
            s3_bucket: s3_bucket,
            s3_path: s3_path,
            file_format: file_format,
            compression: compression
          ) do |batch|
            rows = batch.map { |row| row_processor.process_row(row) }
            yield rows
          end
        end

        def read_from_local_path(file_path, file_format: SNAPSHOT_FILE_FORMAT, compression: SNAPSHOT_COMPRESSION)
          file_reader.read_from_local_path(file_path, file_format: file_format, compression: compression) do |batch|
            rows = batch.map { |row| row_processor.process_row(row) }
            yield rows
          end
        end

        def read_from_stream(stream, file_format: SNAPSHOT_FILE_FORMAT, compression: SNAPSHOT_COMPRESSION)
          file_reader.read_from_stream(stream, file_format: file_format, compression: compression) do |batch|
            rows = batch.map { |row| row_processor.process_row(row) }
            yield rows
          end
        end

        private

        attr_reader :row_processor, :file_reader
      end
    end
  end
end
