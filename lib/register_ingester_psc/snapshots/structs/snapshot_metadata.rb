module RegisterIngesterPsc
  module Snapshots
    class SnapshotMetadata < Dry::Struct
      attribute :source_url, Types::String.optional.default(nil)
      attribute :content_length, Types::Integer.optional.default(nil)
      attribute :retrieved_at, Types::DateTime
      # stored_at
      # parts? split file
    end
  end
end
