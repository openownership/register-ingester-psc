require 'register_ingester_psc/snapshots/structs/snapshot_metadata'
require 'register_ingester_psc/snapshots/structs/snapshot'

module RegisterIngesterPsc
  module Services
    class SnapshotDownloader
      def initialize(http_adapter: HTTP_ADAPTER)
        @http_adapter = http_adapter
      end

      def download(url)
        response = http_adapter.get(url)
        content = response.body

        Snapshots::Snapshot.new(
          metadata: Snapshots::SnapshotMetadata.new(
            source_url: url,
            retrieved_at: Time.zone.now,
            content_length: content.length
          ),
          content: content
        )
      end

      private

      attr_reader :http_adapter
    end
  end
end
