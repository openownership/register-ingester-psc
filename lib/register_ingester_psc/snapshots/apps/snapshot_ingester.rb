require 'register_ingester_psc/config/settings'
require 'register_ingester_psc/config/adapters'

require 'register_ingester_psc/snapshots/services/snapshot_reader'
require 'register_ingester_psc/records_handler'

module RegisterIngesterPsc
  module Snapshots
    module Apps
      class SnapshotIngester
        def self.bash_call(args)
          import_id = args[0]

          SnapshotIngester.new.call(import_id:)
        end

        def initialize(s3_adapter: nil, snapshot_reader: nil, records_handler: nil, s3_bucket: nil, split_snapshots_s3_prefix: nil)
          @s3_adapter = s3_adapter || RegisterIngesterPsc::Config::Adapters::S3_ADAPTER
          @snapshot_reader = snapshot_reader || Services::SnapshotReader.new
          @records_handler = records_handler || RecordsHandler.new
          @s3_bucket = s3_bucket || ENV.fetch('BODS_S3_BUCKET_NAME')
          @split_snapshots_s3_prefix = split_snapshots_s3_prefix || ENV.fetch('SPLIT_SNAPSHOTS_S3_PREFIX')
        end

        def call(import_id:)
          s3_prefix = File.join(split_snapshots_s3_prefix, "import_id=#{import_id}")

          # Calculate s3 paths to import
          s3_paths = s3_adapter.list_objects(s3_bucket:, s3_prefix:)
          print "IMPORTING S3 Paths:\n#{s3_paths} AT #{Time.now}\n\n"

          # Ingest S3 files
          s3_paths.each do |s3_path|
            print "STARTED IMPORTING #{s3_path} AT #{Time.now}\n"

            snapshot_reader.read_from_s3(s3_bucket:, s3_path:) do |records|
              records_handler.handle_records records.compact
            end

            print "COMPLETED IMPORTING #{s3_path} AT #{Time.now}\n"
          end

          print "\n\nINGEST FINISHED AT #{Time.now}\n\n\n"
        end

        private

        attr_reader :snapshot_reader, :records_handler, :s3_bucket, :split_snapshots_s3_prefix, :s3_adapter
      end
    end
  end
end
