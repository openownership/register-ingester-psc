require 'tmpdir'
require 'register_common/services/stream_uploader_service'
require 'register_common/decompressors/decompressor'
require 'register_ingester_psc/config/adapters'

module RegisterIngesterPsc
  module Snapshots
    module Services
      class SnapshotImporter
        DEFAULT_SPLIT_SIZE = 250_000
        DEFAULT_MAX_LINES = nil

        def initialize(
          stream_uploader_service: nil,
          snapshot_downloader: nil,
          stream_decompressor: nil,
          s3_bucket: ENV.fetch('INGESTER_S3_BUCKET_NAME'),
          split_size: DEFAULT_SPLIT_SIZE,
          max_lines: DEFAULT_MAX_LINES
        )
          @s3_bucket = s3_bucket
          @stream_uploader_service = stream_uploader_service || RegisterCommon::Services::StreamUploaderService.new(
            s3_adapter: Config::Adapters::S3_ADAPTER
          )
          @stream_decompressor = stream_decompressor || Decompressors::Decompressor.new
          @snapshot_downloader = snapshot_downloader || Services::SnapshotDownloader.new
          @split_size = split_size
          @max_lines = max_lines
        end

        def import_from_url(url, dst_prefix)
          Dir.mktmpdir do |tmpdir|
            local_path = File.join(tmpdir, 'snapshot.zip')

            snapshot_downloader.download(url: url, local_path: local_path)

            upload_file_chunks(local_path: local_path, dst_prefix: dst_prefix)
          end
        end

        private

        attr_reader :stream_uploader_service, :snapshot_downloader, :stream_decompressor, :s3_bucket, :split_size, :max_lines

        def upload_file_chunks(local_path:, dst_prefix:)
          File.open(local_path, 'rb') do |stream|
            stream_decompressor.with_deflated_stream(
              stream,
              compression: RegisterCommon::Decompressors::CompressionTypes::ZIP
            ) do |deflated|
              stream_uploader_service.upload_in_parts(
                deflated,
                s3_bucket: s3_bucket,
                s3_prefix: dst_prefix,
                split_size: split_size,
                max_lines: max_lines
              )
            end
          end
        end
      end
    end
  end
end
