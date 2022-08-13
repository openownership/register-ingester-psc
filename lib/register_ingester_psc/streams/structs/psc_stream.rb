require 'register_sources_psc/structs/company_record'

require 'register_ingester_psc/types'
require 'register_ingester_psc/streams/structs/psc_stream_event'
require 'register_ingester_psc/streams/enums/psc_stream_resource_kinds'

module RegisterIngesterPsc
  module Streams
    class PscStream < Dry::Struct
      transform_keys(&:to_sym)

      attribute :data, RegisterSourcesPsc::CompanyRecordData
      attribute :event, PscStreamEvent
      attribute :resource_id, Types::String
      attribute :resource_kind, PscStreamResourceKinds
      attribute :resource_uri, Types::String
    end
  end
end
