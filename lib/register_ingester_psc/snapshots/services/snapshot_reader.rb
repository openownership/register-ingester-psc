# frozen_string_literal: true

require 'register_common/services/file_reader'

require_relative '../../config/adapters'
require_relative 'snapshot_row_processor'

module RegisterIngesterPsc
  module Snapshots
    module Services
      class SnapshotReader
        BATCH_SIZE           = 100
        SNAPSHOT_COMPRESSION = RegisterCommon::Decompressors::CompressionTypes::GZIP
        SNAPSHOT_FILE_FORMAT = RegisterCommon::Parsers::FileFormats::JSON

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
            decompressor:,
            parser:,
            batch_size:
          )
        end

        def read_from_s3(s3_bucket:, s3_path:, file_format: SNAPSHOT_FILE_FORMAT, compression: SNAPSHOT_COMPRESSION)
          file_reader.read_from_s3(
            s3_bucket:,
            s3_path:,
            file_format:,
            compression:
          ) do |batch|
            rows = batch.map { |row| row_processor.process_row(row) }
            yield rows
          end
        end

        def read_from_local_path(file_path, file_format: SNAPSHOT_FILE_FORMAT, compression: SNAPSHOT_COMPRESSION)
          file_reader.read_from_local_path(file_path, file_format:, compression:) do |batch|
            rows = batch.map { |row| row_processor.process_row(row) }
            yield rows
          end
        end

        def read_from_stream(stream, file_format: SNAPSHOT_FILE_FORMAT, compression: SNAPSHOT_COMPRESSION)
          file_reader.read_from_stream(stream, file_format:, compression:) do |batch|
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
