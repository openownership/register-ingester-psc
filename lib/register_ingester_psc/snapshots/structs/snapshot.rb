require_relative 'snapshot_metadata'

module RegisterIngesterPsc
  module Snapshots
    class Snapshot < Dry::Struct
      attribute :metadata, SnapshotMetadata
      attribute :content, Types::String.optional.default(nil)
    end
  end
end
