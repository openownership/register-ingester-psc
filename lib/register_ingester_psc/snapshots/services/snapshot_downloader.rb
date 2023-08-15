require 'register_ingester_psc/config/adapters'

module RegisterIngesterPsc
  module Snapshots
    module Services
      class SnapshotDownloader
        def initialize(http_adapter: Config::Adapters::HTTP_ADAPTER)
          @http_adapter = http_adapter
        end

        def download(url:, local_path:)
          response = http_adapter.get(url)

          print("DOWNLOADING #{url} TO #{local_path}\n")
          File.binwrite(local_path, response.body)
          print("DOWNLOADED #{url} TO #{local_path}\n")
        end

        private

        attr_reader :http_adapter
      end
    end
  end
end
