require 'register_ingester_psc/enums/descriptions'
require 'register_ingester_psc/enums/legal_person_kinds'
require 'register_ingester_psc/structs/address'
require 'register_ingester_psc/structs/identification'
require 'register_ingester_psc/structs/links'

module RegisterIngesterPsc
  class LegalPerson < Dry::Struct
    attribute :address, Address
    attribute :ceased_on, Types::Nominal::Date.optional.default(nil)
    attribute :etag, Types::String.optional.default(nil)
    attribute :identification, Identification
    attribute :kind, LegalPersonKinds
    attribute :links, Links
    attribute :name, Types::String
    attribute :natures_of_control, Types.Array(Descriptions)
    attribute :notified_on, Types::Nominal::Date
  end
end
