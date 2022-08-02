module RegisterIngesterPsc
  module Streams
    module Services
      class StreamReader
        def initialize(stream_client:, offset_storer:)
          @stream_client = stream_client
          @offset_storer = offset_storer
        end

        def foreach_record

        end

        def get_last_stored_offset

        end

        def commit_offset
          # will autocommit periodically, or can manually commit
          # defaults
        end

        private

        attr_reader :stream_client, :offset_storer
      end
    end
  end
end
