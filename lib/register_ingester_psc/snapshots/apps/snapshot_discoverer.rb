# frozen_string_literal: true

require_relative '../../config/settings'
require_relative '../services/snapshot_importer'
require_relative '../services/snapshot_link_scraper'

module RegisterIngesterPsc
  module Snapshots
    module Apps
      class SnapshotDiscoverer
        def self.bash_call(args)
          import_id = args[0]

          SnapshotDiscoverer.new.call(import_id:)
        end

        def initialize(
          snapshot_link_scraper: nil,
          snapshot_importer: nil,
          split_snapshots_s3_prefix: ENV.fetch('SPLIT_SNAPSHOTS_S3_PREFIX')
        )
          @snapshot_link_scraper = snapshot_link_scraper || Services::SnapshotLinkScraper.new
          @snapshot_importer = snapshot_importer || Services::SnapshotImporter.new
          @split_snapshots_s3_prefix = split_snapshots_s3_prefix
        end

        def call(import_id:)
          s3_prefix = File.join(split_snapshots_s3_prefix, "import_id=#{import_id}")

          snapshot_link_scraper.list_links.each_with_index do |url, url_index|
            dst_prefix = File.join(s3_prefix, "url_index=#{url_index}")
            snapshot_importer.import_from_url(url, dst_prefix)
          end
        end

        private

        attr_reader :snapshot_link_scraper, :snapshot_importer, :split_snapshots_s3_prefix
      end
    end
  end
end
