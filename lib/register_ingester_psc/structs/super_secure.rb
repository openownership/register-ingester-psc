require 'register_ingester_psc/enums/super_secure_descriptions'
require 'register_ingester_psc/enums/super_secure_kinds'
require 'register_ingester_psc/structs/links'

module RegisterIngesterPsc
  class SuperSecure < Dry::Struct
    attribute :ceased, Types::Nominal::Bool.optional.default(nil)
    attribute :description, SuperSecureDescriptions
    attribute :etag, Types::String
    attribute :kind, SuperSecureKinds
    attribute :links, Links
  end
end
