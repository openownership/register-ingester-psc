module RegisterIngesterPsc
  module Streams
    PscStreamResourceKinds = Types::String.enum(
      'company-profile#company-profile',
      'filing-history#filing-history'
    )

    PscStreamEventTypes = Types::String.enum(
      'changed',
      'deleted'
    )

    class PscStreamEvent < Dry::Struct
      attribute :fields_changed, Types.Array(Types::String).optional.default(nil)
      attribute :published_at, Types::Nominal::DateTime
      attribute :timepoint, Types::Nominal::Integer
      attribute :type, PscStreamEventTypes
    end

    class PscStream < Dry::Struct
      attribute :data, Types::Any # Types::Nominal::Hash
      attribute :event, PscStreamEvent
      attribute :resource_id, Types::String
      attribute :resource_kind, Types::String # PscStreamResourceKinds
      attribute :resource_uri, Types::String
    end
  end
end
