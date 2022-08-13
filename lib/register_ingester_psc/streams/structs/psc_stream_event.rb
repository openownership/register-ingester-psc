require 'register_ingester_psc/types'
require 'register_ingester_psc/streams/enums/psc_stream_event_types'

module RegisterIngesterPsc
  module Streams
    class PscStreamEvent < Dry::Struct
      transform_keys(&:to_sym)

      attribute :fields_changed, Types.Array(Types::String).optional.default(nil)
      attribute :published_at, Types::Nominal::DateTime
      attribute :timepoint, Types::Nominal::Integer
      attribute :type, PscStreamEventTypes
    end
  end
end
